from better_profanity import profanity

profanity.load_words_from_file("palabras.txt")

texto = "Este es un texto que contiene palabra1 y también insulto3."

contiene_insulto = profanity.contains_profanity(texto)

texto_censurado = profanity.censor(texto)
print(texto_censurado)  
