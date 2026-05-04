import { assertConfig, config } from "./config.js";
import { createServer, listenApp } from "./http/server.js";
import { startBotLoop } from "./bot/loop.js";
import { logLine } from "./logger.js";

assertConfig();
logLine("boot", "starting", {
  port: config.port,
  instId: config.instId,
  mode: config.tradingMode,
  bar: config.bar,
});

const app = createServer();
listenApp(app);
startBotLoop();
