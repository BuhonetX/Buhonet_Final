from googletrans import Translator

class TranslationService:
    def __init__(self):
        self.translator = Translator()

    def translate(self, text, dest_lang='en'):
        return self.translator.translate(text, dest=dest_lang).text
