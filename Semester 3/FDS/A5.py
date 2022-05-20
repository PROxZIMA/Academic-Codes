# DSL – ASSIGNMENT 2 – A5

from pprint import pprint

def main():
    string = input('Enter string : ')
    stringfreq = dict()

    for i in string:
        stringfreq[i] = stringfreq.get(i, 0) + 1
    stringfreqword = dict()

    for i in string.split():
        stringfreqword[i] = stringfreqword.get(i, 0) + 1

    print(f'\nWord with maximum length : {max(string.split(), key=len)}')
    print(f'\nFrequency of each character :')
    pprint(stringfreq)

    pali = input('\nEnter a string to check Palindrome: ')
    print(f"Given string is {'not ' if pali != pali[::-1] else ''}a palindrome.\n")

    print(f"First occurrence of given substring is at index : {string.index(input('Enter substring to be searched : '))}")

    print(f'\nFrequency of each word :')
    pprint(stringfreqword)


if __name__ == "__main__":
    main()



"""

---------------- OUTPUT -----------------

Enter string : Dali is a hunting goddess from the mythology of the Georgian people. The patron of hoofed wild mountain animals, she was said to reward hunters who obeyed her taboos and to punish violators. She was usually described as a beautiful nude woman with golden hair and glowing skin, although she sometimes took on the form of her favored animals. Stories depict her taking human lovers and jealously killing them, and later clashing with her rival Saint George. After the rise of Christianity in Georgia, the stories told about Dali changed; Saint George was presented as having the power to overrule her, and she began to be conflated with a malicious nature spirit called the ali. As a patron of the hunt, she has been compared with Artemis of Greek mythology, a hag in Scottish mythology called the glaistig, and a maiden from folklore who tames a unicorn. Her associations with gold, seduction, and the morning star have led scholars to draw connections with goddesses such as Aphrodite and Ishtar.

Word with maximum length : Christianity

Frequency of each character :
{' ': 168,
 ',': 10,
 '.': 7,
 ';': 1,
 'A': 4,
 'C': 1,
 'D': 2,
 'G': 5,
 'H': 1,
 'I': 1,
 'S': 5,
 'T': 1,
 'a': 74,
 'b': 8,
 'c': 17,
 'd': 36,
 'e': 82,
 'f': 15,
 'g': 25,
 'h': 54,
 'i': 59,
 'j': 1,
 'k': 6,
 'l': 39,
 'm': 20,
 'n': 52,
 'o': 72,
 'p': 11,
 'r': 47,
 's': 55,
 't': 64,
 'u': 20,
 'v': 7,
 'w': 17,
 'y': 10}

Enter a string to check Palindrome: malayalam
Given string is a palindrome.

Enter substring to be searched : hunt
First occurrence of given substring is at index : 10

Frequency of each word :
{'After': 1,
 'Aphrodite': 1,
 'Artemis': 1,
 'As': 1,
 'Christianity': 1,
 'Dali': 2,
 'George': 1,
 'George.': 1,
 'Georgia,': 1,
 'Georgian': 1,
 'Greek': 1,
 'Her': 1,
 'Ishtar.': 1,
 'Saint': 2,
 'Scottish': 1,
 'She': 1,
 'Stories': 1,
 'The': 1,
 'a': 7,
 'about': 1,
 'ali.': 1,
 'although': 1,
 'and': 8,
 'animals,': 1,
 'animals.': 1,
 'as': 3,
 'associations': 1,
 'be': 1,
 'beautiful': 1,
 'been': 1,
 'began': 1,
 'called': 2,
 'changed;': 1,
 'clashing': 1,
 'compared': 1,
 'conflated': 1,
 'connections': 1,
 'depict': 1,
 'described': 1,
 'draw': 1,
 'favored': 1,
 'folklore': 1,
 'form': 1,
 'from': 2,
 'glaistig,': 1,
 'glowing': 1,
 'goddess': 1,
 'goddesses': 1,
 'gold,': 1,
 'golden': 1,
 'hag': 1,
 'hair': 1,
 'has': 1,
 'have': 1,
 'having': 1,
 'her': 4,
 'her,': 1,
 'hoofed': 1,
 'human': 1,
 'hunt,': 1,
 'hunters': 1,
 'hunting': 1,
 'in': 2,
 'is': 1,
 'jealously': 1,
 'killing': 1,
 'later': 1,
 'led': 1,
 'lovers': 1,
 'maiden': 1,
 'malicious': 1,
 'morning': 1,
 'mountain': 1,
 'mythology': 2,
 'mythology,': 1,
 'nature': 1,
 'nude': 1,
 'obeyed': 1,
 'of': 6,
 'on': 1,
 'overrule': 1,
 'patron': 2,
 'people.': 1,
 'power': 1,
 'presented': 1,
 'punish': 1,
 'reward': 1,
 'rise': 1,
 'rival': 1,
 'said': 1,
 'scholars': 1,
 'seduction,': 1,
 'she': 4,
 'skin,': 1,
 'sometimes': 1,
 'spirit': 1,
 'star': 1,
 'stories': 1,
 'such': 1,
 'taboos': 1,
 'taking': 1,
 'tames': 1,
 'the': 10,
 'them,': 1,
 'to': 5,
 'told': 1,
 'took': 1,
 'unicorn.': 1,
 'usually': 1,
 'violators.': 1,
 'was': 3,
 'who': 2,
 'wild': 1,
 'with': 6,
 'woman': 1}

"""
