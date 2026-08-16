import express, { Response } from 'express';
import { authenticate, AuthRequest } from '../middleware/authenticate';
import { dailyGoalsService } from '../services/dailyGoalsService';

const router = express.Router();

function dailyGoalI18n(s: {
  nl: string;
  en: string;
  es: string;
  de: string;
  fr: string;
  it: string;
  pl: string;
  pt: string;
}) {
  return {
    messageNl: s.nl,
    messageEn: s.en,
    messageEs: s.es,
    messageDe: s.de,
    messageFr: s.fr,
    messageIt: s.it,
    messagePl: s.pl,
    messagePt: s.pt,
  };
}

router.get('/daily', authenticate, async (req: AuthRequest, res: Response) => {
  try {
    const playerId = req.player!.id;
    const data = await dailyGoalsService.getDailyGoals(playerId);
    return res.status(200).json({ success: true, data });
  } catch (error) {
    console.error('[GET /daily-goals/daily] error', error);
    return res.status(500).json({ success: false, event: 'error.internal', params: {} });
  }
});

router.get('/weekly', authenticate, async (req: AuthRequest, res: Response) => {
  try {
    const playerId = req.player!.id;
    const data = await dailyGoalsService.getWeeklyGoals(playerId);
    return res.status(200).json({ success: true, data });
  } catch (error) {
    console.error('[GET /daily-goals/weekly] error', error);
    return res.status(500).json({ success: false, event: 'error.internal', params: {} });
  }
});

router.post('/daily/claim', authenticate, async (req: AuthRequest, res: Response) => {
  try {
    const playerId = req.player!.id;
    const goalKey = String(req.body?.goalKey ?? '').trim();
    if (!goalKey) {
      return res.status(400).json({
        success: false,
        event: 'error.validation',
        params: {
          messageNl: 'Kies een doel om te claimen.',
          messageEn: 'Choose a goal to claim.',
        },
      });
    }

    const result = await dailyGoalsService.claimDailyGoal(playerId, goalKey);
    const isWeekly = goalKey.startsWith('weekly_');
    const rewardNl = `+€${result.rewardCash} en +${result.rewardXp} XP`;
    const rewardEn = `+€${result.rewardCash} and +${result.rewardXp} XP`;
    return res.status(200).json({
      success: true,
      data: result,
      messageNl: isWeekly ? `Weekdoel geclaimd: ${rewardNl}` : `Dagdoel geclaimd: ${rewardNl}`,
      messageEn: isWeekly ? `Weekly goal claimed: ${rewardEn}` : `Daily goal claimed: ${rewardEn}`,
    });
  } catch (error: any) {
    const code = String(error?.code ?? error?.message ?? '');
    if (code === 'NOT_COMPLETE') {
      return res.status(400).json({
        success: false,
        event: 'daily_goal.not_complete',
        params: dailyGoalI18n({
          nl: 'Dit doel is nog niet voltooid.',
          en: 'This goal is not complete yet.',
          es: 'Este objetivo aún no está completo.',
          de: 'Dieses Ziel ist noch nicht abgeschlossen.',
          fr: "Cet objectif n'est pas encore terminé.",
          it: 'Questo obiettivo non è ancora completato.',
          pl: 'Ten cel nie jest jeszcze ukończony.',
          pt: 'Este objetivo ainda não está concluído.',
        }),
      });
    }
    if (code === 'ALREADY_CLAIMED') {
      return res.status(400).json({
        success: false,
        event: 'daily_goal.already_claimed',
        params: dailyGoalI18n({
          nl: 'Dit doel is al geclaimd.',
          en: 'This goal was already claimed.',
          es: 'Este objetivo ya fue reclamado.',
          de: 'Dieses Ziel wurde bereits eingelöst.',
          fr: 'Cet objectif a déjà été réclamé.',
          it: 'Questo obiettivo è stato già riscattato.',
          pl: 'Ten cel został już odebrany.',
          pt: 'Este objetivo já foi resgatado.',
        }),
      });
    }
    if (code === 'INVALID_GOAL') {
      return res.status(400).json({
        success: false,
        event: 'daily_goal.invalid',
        params: dailyGoalI18n({
          nl: 'Ongeldig dagdoel.',
          en: 'Invalid daily goal.',
          es: 'Objetivo diario no válido.',
          de: 'Ungültiges Tagesziel.',
          fr: 'Objectif quotidien invalide.',
          it: 'Obiettivo giornaliero non valido.',
          pl: 'Nieprawidłowy cel dzienny.',
          pt: 'Objetivo diário inválido.',
        }),
      });
    }

    console.error('[POST /daily-goals/daily/claim] error', error);
    return res.status(500).json({ success: false, event: 'error.internal', params: {} });
  }
});

export default router;

