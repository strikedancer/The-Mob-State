ALTER TABLE `players`
  CHANGE COLUMN `mollieCustomerId` `stripeCustomerId` VARCHAR(255) NULL;

ALTER TABLE `crews`
  CHANGE COLUMN `mollieSubscriptionId` `stripeSubscriptionId` VARCHAR(255) NULL;

RENAME TABLE `mollie_payment_fulfillments` TO `stripe_payment_fulfillments`;

ALTER TABLE `stripe_payment_fulfillments`
  CHANGE COLUMN `molliePaymentId` `stripeSessionId` VARCHAR(64) NOT NULL;
