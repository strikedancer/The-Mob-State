bool pwaIsStandalone() => false;

bool pwaLooksLikeMobileWeb() => false;

bool pwaIsIosSafari() => false;

bool pwaCanNativePrompt() => false;

void pwaListenForNativePrompt(void Function() onReady) {}

Future<String> pwaPromptNativeInstall() async => 'unavailable';
