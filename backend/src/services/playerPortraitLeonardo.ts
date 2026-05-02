import axios from 'axios';
import FormData from 'form-data';
import {
  LEONARDO_MODEL_ID_KINO_XL,
  LEONARDO_PREPROCESSOR_CHARACTER_REF,
  PORTRAIT_NEGATIVE_PROMPT,
  PORTRAIT_POSITIVE_PROMPT,
} from '../constants/playerPortrait';

const INIT_IMAGE_URL = 'https://cloud.leonardo.ai/api/rest/v1/init-image';
const GENERATIONS_URL = 'https://cloud.leonardo.ai/api/rest/v1/generations';
const GENERATION_STATUS_URL = 'https://cloud.leonardo.ai/api/rest/v1/generations';

function getApiKey(): string {
  const k = process.env.LEONARDO_API_KEY?.trim();
  if (!k) {
    throw new Error('LEONARDO_API_KEY_MISSING');
  }
  return k;
}

function headersJson(): Record<string, string> {
  return {
    Authorization: `Bearer ${getApiKey()}`,
    'Content-Type': 'application/json',
    accept: 'application/json',
  };
}

function extractGenerationId(payload: unknown): string | null {
  if (Array.isArray(payload)) {
    payload = payload[0] ?? {};
  }
  if (!payload || typeof payload !== 'object') return null;
  const p = payload as Record<string, unknown>;
  const sd = p.sdGenerationJob as Record<string, unknown> | undefined;
  if (sd?.generationId) return String(sd.generationId);
  if (p.generationId) return String(p.generationId);
  if (p.id) return String(p.id);
  const gen = p.generate as Record<string, unknown> | undefined;
  if (gen?.generationId) return String(gen.generationId);
  const data = p.data as Record<string, unknown> | undefined;
  if (data?.generationId) return String(data.generationId);
  return null;
}

function extractImageUrl(payload: unknown): string | null {
  if (Array.isArray(payload)) {
    payload = payload[0] ?? {};
  }
  if (!payload || typeof payload !== 'object') return null;
  const p = payload as Record<string, unknown>;
  const gens =
    (p.generations_by_pk as Record<string, unknown>) ||
    (p.generations as Record<string, unknown>);
  if (gens && typeof gens === 'object') {
    const images = (gens as { generated_images?: unknown[] }).generated_images;
    if (images?.[0] && typeof images[0] === 'object') {
      const im = images[0] as Record<string, unknown>;
      const u = im.url ?? im.imageUrl;
      if (typeof u === 'string') return u;
    }
  }
  const images = p.generated_images as unknown[] | undefined;
  if (images?.[0] && typeof images[0] === 'object') {
    const im = images[0] as Record<string, unknown>;
    const u = im.url ?? im.imageUrl;
    if (typeof u === 'string') return u;
  }
  return null;
}

async function uploadInitImageToLeonardo(
  buffer: Buffer,
  extension: 'png' | 'jpg' | 'jpeg' | 'webp'
): Promise<string> {
  const res = await axios.post(
    INIT_IMAGE_URL,
    { extension: extension === 'jpeg' ? 'jpg' : extension },
    { headers: headersJson(), timeout: 120_000 }
  );
  const ui = res.data?.uploadInitImage as
    | { id?: string; url?: string; fields?: string }
    | undefined;
  if (!ui?.id || !ui?.url || !ui?.fields) {
    throw new Error('LEONARDO_INIT_IMAGE_BAD_RESPONSE');
  }

  const fields = JSON.parse(ui.fields) as Record<string, string>;
  const form = new FormData();
  for (const [k, v] of Object.entries(fields)) {
    form.append(k, v);
  }
  const mime =
    extension === 'png'
      ? 'image/png'
      : extension === 'webp'
        ? 'image/webp'
        : 'image/jpeg';
  form.append('file', buffer, { filename: `upload.${extension === 'jpeg' ? 'jpg' : extension}`, contentType: mime });

  await axios.post(ui.url, form, {
    headers: form.getHeaders(),
    maxBodyLength: Infinity,
    maxContentLength: Infinity,
    timeout: 120_000,
  });

  return ui.id;
}

async function waitForGenerationImage(generationId: string, timeoutMs = 300_000): Promise<string> {
  const deadline = Date.now() + timeoutMs;
  while (Date.now() < deadline) {
    const r = await axios.get(`${GENERATION_STATUS_URL}/${generationId}`, {
      headers: {
        Authorization: `Bearer ${getApiKey()}`,
        accept: 'application/json',
      },
      timeout: 60_000,
    });
    const url = extractImageUrl(r.data);
    if (url) return url;
    await new Promise((r) => setTimeout(r, 3000));
  }
  throw new Error('LEONARDO_GENERATION_TIMEOUT');
}

/**
 * Upload selfie buffer → Leonardo Character Reference → PNG bytes.
 */
export async function generateGangsterPortraitFromSelfie(
  imageBuffer: Buffer,
  mime: string
): Promise<Buffer> {
  let ext: 'png' | 'jpg' | 'jpeg' | 'webp' = 'jpg';
  if (mime.includes('png')) ext = 'png';
  else if (mime.includes('webp')) ext = 'webp';
  else if (mime.includes('jpeg') || mime.includes('jpg')) ext = 'jpg';

  const initImageId = await uploadInitImageToLeonardo(imageBuffer, ext);

  const body = {
    height: 1024,
    width: 1024,
    modelId: LEONARDO_MODEL_ID_KINO_XL,
    prompt: PORTRAIT_POSITIVE_PROMPT,
    negativePrompt: PORTRAIT_NEGATIVE_PROMPT,
    num_images: 1,
    alchemy: true,
    presetStyle: 'CINEMATIC',
    photoReal: true,
    photoRealVersion: 'v2',
    controlnets: [
      {
        initImageId,
        initImageType: 'UPLOADED',
        preprocessorId: LEONARDO_PREPROCESSOR_CHARACTER_REF,
        strengthType: 'High',
      },
    ],
  };

  const genRes = await axios.post(GENERATIONS_URL, body, {
    headers: headersJson(),
    timeout: 120_000,
  });

  const genId = extractGenerationId(genRes.data);
  if (!genId) {
    throw new Error('LEONARDO_NO_GENERATION_ID');
  }

  const outUrl = await waitForGenerationImage(genId);
  const imgRes = await axios.get<ArrayBuffer>(outUrl, {
    responseType: 'arraybuffer',
    timeout: 120_000,
  });
  return Buffer.from(imgRes.data);
}
