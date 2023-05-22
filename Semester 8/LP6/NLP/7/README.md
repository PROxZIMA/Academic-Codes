
---
## SUPERVISED
---

Filename - ./supervised.py

Description - HMM based POS tagger using supervised learning technique.

Usage - python supervised.py <language> <test_file_path>

Example - To execute for hindi, telugu, kannada, tamil enter the below line.

```bash
$ python supervised.py 0 ./data/hindi_testing.txt
$ python supervised.py 1 ./data/telugu_testing.txt
$ python supervised.py 2 ./data/kannada_testing.txt
$ python supervised.py 3 ./data/tamil_testing.txt
```

Output
- ./output/<language>_tags.txt
- For each word in test file, <word>_<tag> will be printed in output file.

Argument Details

    -- "language"

        ~ 0 - Hindi
        ~ 1 - Telugu
        ~ 2 - Kannada
        ~ 3 - Tamil


    -- "test_file_path"

        ~ Path of the file that contains testing sentences.
        ~ Each line should contain one sentence.
        ~ See ./data/hindi_testing.txt for reference.


--------------------------------------------------------------------------

## UNSUPERVISED
--------------------------------------------------------------------------

Filename - ./unsupervised.py

Description - HMM based POS tagger using unsupervised learning technique.

Usage - python unsupervised.py <language> <test_file_path>

Example - To execute for hindi, telugu, kannada, tamil enter the below line respectively.

```bash
$ python unsupervised.py 0 ./data/hindi_testing.txt
$ python unsupervised.py 1 ./data/telugu_testing.txt
$ python unsupervised.py 2 ./data/kannada_testing.txt
$ python unsupervised.py 3 ./data/tamil_testing.txt
```
Output
- ./output/<language>_clusters.txt
- For each clusters, words in that clusters will be printed in output file.
- ./output/<language>_tags_unsupervised.txt
- For each word in test file, <word>_<tag> will be printed in output file.

Argument Details

    -- "language"

        ~ 0 - Hindi
        ~ 1 - Telugu
        ~ 2 - Kannada
        ~ 3 - Tamil


    -- "test_file_path"

        ~ Path of the file that contains testing sentences.
        ~ Each line should contain one sentence.
        ~ See ./data/hindi_testing.txt for reference.

---
