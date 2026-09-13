-- Per-player inbox hide so read messages can leave your list without
-- deleting the other player's copy.
ALTER TABLE `direct_messages`
  ADD COLUMN `hiddenForSender` BOOLEAN NOT NULL DEFAULT false,
  ADD COLUMN `hiddenForReceiver` BOOLEAN NOT NULL DEFAULT false;

CREATE INDEX `direct_messages_receiverId_hiddenForReceiver_read_idx`
  ON `direct_messages`(`receiverId`, `hiddenForReceiver`, `read`);
