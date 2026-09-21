import { COURT_RECORD_AMNESTY_DISPLAY_NAME, COURT_RECORD_AMNESTY_IMAGE, COURT_RECORD_AMNESTY_MESSAGE } from '../data/courtRecordAmnestyPromo';
import { expungeAllCriminalRecordsAmnesty } from '../services/judgeService';
import { globalChatService } from '../services/globalChatService';

async function main(): Promise<void> {
  const wipe = await expungeAllCriminalRecordsAmnesty();
  const posted = await globalChatService.sendSystemAnnouncement(
    COURT_RECORD_AMNESTY_DISPLAY_NAME,
    COURT_RECORD_AMNESTY_MESSAGE,
    { imageUrl: COURT_RECORD_AMNESTY_IMAGE, force: true },
  );
  console.log(
    JSON.stringify({
      playersCleared: wipe.playersCleared,
      recordsCleared: wipe.recordsCleared,
      announcementId: posted?.id ?? null,
    }),
  );
}

void main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
