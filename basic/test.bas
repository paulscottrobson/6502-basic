;
;	Built using seed 74677
;
assert ("b"+"c") = "bc"
assert ("a"+"cc") = "acc"
assert ("baab"+"") = "baab"
assert (""+"") = ""
assert ("bcab"+"c") = "bcabc"
assert ("da" = "dc") = 0
assert ("cca"+"b") = "ccab"
assert ("bbcb" > "b") = -1
assert ("bc"+"addc") = "bcaddc"
assert ("aa" <= "ccb") = -1
assert ("d"+"aabd") = "daabd"
assert ("adb" > "bbb") = 0
assert ("c" <> "adbd") = -1
assert ("d" = "cd") = 0
assert ("cdca" <> "abb") = -1
assert ("cacb"+"aad") = "cacbaad"
assert ("d"+"") = "d"
assert ("bcbd"+"c") = "bcbdc"
assert ("" < "") = 0
assert ("baaa" = "bbcc") = 0
assert (""+"") = ""
assert ("ba" > "") = -1
assert ("ddd" = "") = 0
assert ("c"+"b") = "cb"
assert ("c"+"") = "c"
assert ("c"+"aad") = "caad"
assert ("" > "") = 0
assert ("b" <= "ddb") = -1
assert ("bdd"+"b") = "bddb"
assert ("c" < "") = 0
assert ("b"+"") = "b"
assert (""+"cddd") = "cddd"
assert ("b" <= "dca") = -1
assert ("d" > "") = -1
assert ("dc" <> "cacb") = -1
assert (""+"ac") = "ac"
assert ("" < "bb") = -1
assert ("a" = "cb") = 0
assert ("dcbd" <= "c") = 0
assert ("abbb"+"cabb") = "abbbcabb"
assert ("bacb" >= "dda") = 0
assert ("c"+"aacd") = "caacd"
assert ("ca" = "") = 0
assert ("aadb" <> "ba") = -1
assert ("" <> "cbb") = -1
assert ("cb"+"cd") = "cbcd"
assert ("cbc"+"acc") = "cbcacc"
assert ("ab"+"") = "ab"
assert ("bbaa" > "bc") = 0
assert ("cdaa"+"b") = "cdaab"
assert ("bdb" > "bcbc") = -1
assert (""+"ad") = "ad"
assert (""+"bb") = "bb"
assert ("adb"+"c") = "adbc"
assert ("dcd" >= "") = -1
assert ("ddb" >= "a") = -1
assert ("bdcc" >= "") = -1
assert ("" < "dac") = -1
assert ("dbcb"+"") = "dbcb"
assert ("c" > "badc") = -1
assert ("caa"+"c") = "caac"
assert ("a" > "cada") = 0
assert ("cccd" >= "cdc") = 0
assert ("cd" = "dcc") = 0
assert ("" <= "dbcd") = -1
assert ("" > "") = 0
assert ("c"+"d") = "cd"
assert ("a" < "cda") = -1
assert ("cb"+"dac") = "cbdac"
assert ("aa" <= "ca") = -1
assert ("cba"+"bdb") = "cbabdb"
assert ("c"+"cdc") = "ccdc"
assert ("cdc"+"dab") = "cdcdab"
assert ("d" <= "cdd") = 0
assert ("b" >= "d") = 0
assert (""+"cda") = "cda"
assert ("bd"+"") = "bd"
assert ("bd" > "") = -1
assert ("bc" <> "") = -1
assert ("b"+"") = "b"
assert ("bbaa"+"d") = "bbaad"
assert ("" <= "aadc") = -1
assert ("ccb"+"") = "ccb"
assert ("dbc" < "bdd") = 0
assert ("dba"+"aa") = "dbaaa"
assert (""+"") = ""
assert ("da"+"bd") = "dabd"
assert (""+"bd") = "bd"
assert ("ac" <> "dba") = -1
assert ("cddb"+"c") = "cddbc"
assert ("bbb" > "") = -1
assert ("dc"+"b") = "dcb"
assert ("dbbc" = "c") = 0
assert ("cad"+"bbdc") = "cadbbdc"
assert ("b"+"bb") = "bbb"
assert ("bdbb" <= "bb") = 0
assert (""+"") = ""
assert ("abcc" > "d") = 0
assert ("ada"+"dbc") = "adadbc"
assert ("abc"+"dadb") = "abcdadb"
assert (""+"bcd") = "bcd"
assert ("ab" <> "") = -1
assert ("ab"+"c") = "abc"
assert ("dcd"+"bccc") = "dcdbccc"
assert ("d"+"a") = "da"
assert ("bb"+"dcc") = "bbdcc"
assert ("c"+"adac") = "cadac"
assert ("ddcc"+"") = "ddcc"
assert (""+"db") = "db"
assert ("" > "bb") = 0
assert ("cbd" > "aab") = -1
assert ("cdc" <> "") = -1
assert ("acbc" > "cdc") = 0
assert ("dc" >= "") = -1
assert ("ac"+"c") = "acc"
assert ("aad" >= "db") = 0
assert ("dbbd"+"dc") = "dbbddc"
assert ("bd" <= "b") = 0
assert ("cd"+"a") = "cda"
assert (""+"d") = "d"
assert ("cd"+"") = "cd"
assert ("b" >= "aacd") = -1
assert ("ba" <> "b") = -1
assert ("c" >= "cb") = 0
assert ("bcb" = "bda") = 0
assert ("bba"+"aaa") = "bbaaaa"
assert ("da" <> "d") = -1
assert ("bbd" = "adda") = 0
assert ("aada"+"") = "aada"
assert ("da"+"adbd") = "daadbd"
assert ("" = "") = -1
assert ("d"+"bdad") = "dbdad"
assert ("d"+"") = "d"
assert ("bbab" = "dcaa") = 0
assert ("ac" <= "cd") = -1
assert ("ada" = "d") = 0
assert ("ccad" <= "") = 0
assert ("" >= "bacb") = 0
assert ("" <> "cdcc") = -1
assert ("aaab" < "dc") = -1
assert ("cad"+"d") = "cadd"
assert ("d"+"") = "d"
assert ("ba"+"cba") = "bacba"
assert ("cbd" <> "ddc") = -1
assert ("d"+"") = "d"
assert ("cb"+"addd") = "cbaddd"
assert ("" <> "daac") = -1
assert ("bdb"+"b") = "bdbb"
assert ("daa" <> "") = -1
assert ("aba"+"adca") = "abaadca"
assert ("dcc"+"da") = "dccda"
assert ("ba" <> "cdbb") = -1
assert ("cbda"+"dac") = "cbdadac"
assert ("abbc" > "c") = 0
assert ("acc" <> "b") = -1
assert ("bb"+"dc") = "bbdc"
assert ("cccc" > "ab") = -1
assert ("cdcc" <= "") = 0
assert ("bdad" = "") = 0
assert ("bda" < "b") = 0
assert (""+"c") = "c"
assert ("d"+"cbbd") = "dcbbd"
assert (""+"dbcc") = "dbcc"
assert ("abdb"+"d") = "abdbd"
assert ("ccc" > "bad") = -1
assert ("" <= "cdc") = -1
assert ("aca"+"bda") = "acabda"
assert ("c" <> "d") = -1
assert ("cdb" = "") = 0
assert ("a" >= "baa") = 0
assert ("c"+"d") = "cd"
assert ("ab" < "dd") = -1
assert ("bba"+"cdd") = "bbacdd"
assert ("a" < "cbdc") = -1
assert (""+"b") = "b"
assert (""+"dbb") = "dbb"
assert ("a"+"ccd") = "accd"
assert ("ddca" <> "ccca") = -1
assert ("cdd" >= "bac") = -1
assert ("bab"+"ab") = "babab"
assert ("b" <> "") = -1
assert ("dc" >= "") = -1
assert ("dbbd" > "cc") = -1
assert ("cdc" <> "caa") = -1
assert (""+"cdcb") = "cdcb"
assert ("bad"+"") = "bad"
assert ("cb"+"d") = "cbd"
assert ("c" > "dcda") = 0
assert ("a"+"ab") = "aab"
assert (""+"") = ""
assert ("b"+"c") = "bc"
assert ("dab" <= "") = 0
assert ("baab" < "bc") = -1
assert ("aa"+"c") = "aac"
assert ("b" <> "") = -1
assert ("aaab"+"d") = "aaabd"
assert ("ab" <> "db") = -1
assert (""+"babb") = "babb"
assert ("ada"+"") = "ada"
assert ("d" > "bd") = -1
assert ("c"+"dabd") = "cdabd"
assert ("c"+"cbd") = "ccbd"
assert ("bcda"+"cca") = "bcdacca"
assert (""+"cba") = "cba"
assert ("ab" > "c") = 0
assert ("dcdc" > "") = -1
assert ("b"+"bb") = "bbb"
assert ("d" < "ca") = 0
assert (""+"") = ""
assert ("bcbb" <= "cd") = -1
assert ("abcc"+"caca") = "abcccaca"
assert ("acd" > "ac") = -1
assert (""+"abcd") = "abcd"
assert ("cad"+"bdcc") = "cadbdcc"
assert ("aaa" > "bc") = 0
assert ("ca" >= "adb") = -1
assert ("a"+"") = "a"
assert ("" = "d") = 0
assert ("cda" = "") = 0
assert ("cdba" <= "ccc") = 0
assert ("d" > "cadb") = -1
assert ("b" <> "aca") = -1
assert ("ac"+"acad") = "acacad"
assert ("ccab"+"aa") = "ccabaa"
assert ("ccbb"+"") = "ccbb"
assert ("" < "cb") = -1
assert ("ab" >= "b") = 0
assert ("cdc" = "d") = 0
assert ("dcaa" <= "cbc") = 0
assert ("dcdb" > "abba") = -1
assert ("aaad" = "b") = 0
assert ("bad"+"a") = "bada"
assert ("ccdd" >= "dadb") = 0
assert ("cc"+"ab") = "ccab"
assert ("cbb" >= "b") = -1
assert ("bbc" > "da") = 0
assert ("bbd" < "bb") = 0
assert ("bb"+"") = "bb"
assert ("" >= "dcd") = 0
assert ("a"+"cd") = "acd"
assert ("c"+"d") = "cd"
assert ("" < "c") = -1
assert ("bdca" >= "ccdd") = 0
assert ("bc" >= "dbcb") = 0
assert ("dd" >= "bbcc") = -1
assert ("c" <= "") = 0
assert ("bd"+"b") = "bdb"
assert ("cbdc"+"cca") = "cbdccca"
assert ("bac"+"acbd") = "bacacbd"
assert ("cbc"+"bbaa") = "cbcbbaa"
assert ("aac"+"bbd") = "aacbbd"
assert (""+"") = ""
assert ("d" >= "dadc") = 0
assert ("c" <> "d") = -1
assert ("bc"+"d") = "bcd"
assert ("a" = "c") = 0
assert ("cbba" >= "bdb") = -1
assert ("" = "bb") = 0
assert ("bbca" = "cdc") = 0
assert ("aca"+"bacd") = "acabacd"
assert ("dbdd"+"bc") = "dbddbc"
assert ("a" <= "adc") = -1
assert ("ccb"+"dcab") = "ccbdcab"
assert ("dc"+"") = "dc"
assert ("bba"+"dacc") = "bbadacc"
assert ("" < "bba") = -1
assert ("" = "acda") = 0
assert ("ad"+"b") = "adb"
assert ("caca" < "") = 0
assert (""+"") = ""
assert (""+"bcad") = "bcad"
assert ("ab" < "bbaa") = -1
assert ("aa"+"") = "aa"
assert ("ada" >= "ab") = -1
assert ("c" <> "dc") = -1
assert (""+"") = ""
assert ("cdb"+"a") = "cdba"
assert ("addd" = "bdc") = 0
assert (""+"db") = "db"
assert ("cbcb"+"ccad") = "cbcbccad"
assert ("bbb"+"cda") = "bbbcda"
assert ("a"+"dd") = "add"
assert ("dd"+"ba") = "ddba"
assert ("" >= "ab") = 0
assert (""+"") = ""
assert ("bcad"+"bbd") = "bcadbbd"
assert ("baad"+"ddcb") = "baadddcb"
assert ("c"+"dcdc") = "cdcdc"
assert ("dbad" <> "cdbb") = -1
assert ("d" = "ddd") = 0
assert ("dd"+"a") = "dda"
assert (""+"b") = "b"
assert ("" >= "bda") = 0
assert ("cc" >= "d") = 0
assert ("abb" < "cba") = -1
assert ("c" >= "") = -1
assert ("cbdb" <= "") = 0
assert ("bdcd"+"addb") = "bdcdaddb"
assert ("dc" < "bd") = 0
assert ("c" < "d") = -1
assert ("a" <> "a") = 0
assert ("dda" = "bbc") = 0
assert ("dbdd" >= "dc") = 0
assert ("adc" > "aadc") = -1
assert ("d"+"") = "d"
assert ("d" >= "cab") = -1
assert ("" <> "d") = -1
assert ("dcba"+"ccad") = "dcbaccad"
assert ("adbc"+"dd") = "adbcdd"
assert (""+"da") = "da"
assert ("bd" < "") = 0
assert ("bccc" <= "cb") = -1
assert ("adbd"+"a") = "adbda"
assert ("adb"+"ac") = "adbac"
assert ("bab" >= "dccc") = 0
assert ("b" = "") = 0
assert ("d"+"cab") = "dcab"
assert ("dcab"+"a") = "dcaba"
assert ("bcca"+"ac") = "bccaac"
assert ("" > "bac") = 0
assert (""+"abdb") = "abdb"
assert ("d"+"bd") = "dbd"
assert ("" <> "caab") = -1
assert ("cda" < "") = 0
assert ("ba"+"a") = "baa"
assert (""+"daa") = "daa"
assert ("dcd" > "bdc") = -1
assert (""+"dcad") = "dcad"
assert ("aba" <> "bc") = -1
assert ("cdcb"+"bd") = "cdcbbd"
assert (""+"abbb") = "abbb"
assert ("" >= "dc") = 0
assert ("bdcb" > "dcaa") = 0
assert ("acb"+"dd") = "acbdd"
assert ("ca"+"") = "ca"
assert ("c"+"") = "c"
assert ("a" <= "dbbd") = -1
assert ("" <= "ddd") = -1
assert ("aa"+"bdac") = "aabdac"
assert ("cbc"+"bdbc") = "cbcbdbc"
assert ("" <> "dc") = -1
assert ("" >= "daad") = 0
assert ("ccab" >= "cad") = -1
assert ("d" > "c") = -1
assert ("db"+"bcbc") = "dbbcbc"
assert ("cbd"+"") = "cbd"
assert ("bbbb"+"") = "bbbb"
assert ("db"+"ab") = "dbab"
assert ("cbcb" < "bd") = 0
assert ("bbdb" <= "ddb") = -1
assert ("" > "dddd") = 0
assert ("a" <> "abcb") = -1
assert ("db" >= "d") = -1
assert ("bdac" <= "ba") = 0
assert ("dcda" = "ccda") = 0
assert ("c"+"cc") = "ccc"
assert ("dda"+"d") = "ddad"
assert ("dcca" <= "ca") = 0
assert ("dbb" >= "a") = -1
assert ("acad"+"") = "acad"
assert ("a"+"ccc") = "accc"
assert (""+"ddad") = "ddad"
assert (""+"dcac") = "dcac"
assert ("d" = "cb") = 0
assert ("cbd" >= "bdc") = -1
assert ("bd" > "cdcb") = 0
assert ("" <= "") = -1
assert ("dcb"+"aacd") = "dcbaacd"
assert (""+"da") = "da"
assert ("aad" > "bd") = 0
assert ("baac"+"b") = "baacb"
assert ("caa" >= "ad") = -1
assert ("acca" <= "a") = 0
assert ("b" <= "b") = -1
assert ("ccda"+"") = "ccda"
assert ("ad" < "") = 0
assert ("cacb"+"") = "cacb"
assert ("bd"+"aad") = "bdaad"
assert ("acad" < "ca") = -1
assert ("cba" < "ddc") = -1
assert ("abda"+"bdb") = "abdabdb"
assert ("a"+"bbcb") = "abbcb"
assert ("bdcb"+"") = "bdcb"
assert ("c" > "ccac") = 0
assert ("c" < "da") = -1
assert ("d"+"") = "d"
assert (""+"cd") = "cd"
assert ("baab" < "") = 0
assert ("caa" >= "bacb") = -1
assert (""+"ac") = "ac"
assert ("" <= "bddd") = -1
assert ("c"+"bccc") = "cbccc"
assert ("cda"+"bbdb") = "cdabbdb"
assert (""+"") = ""
assert ("a" <> "c") = -1
assert ("dd" = "bbb") = 0
assert (""+"bb") = "bb"
assert ("c" >= "") = -1
assert ("ccb"+"a") = "ccba"
assert ("add" <= "dc") = -1
assert ("ab"+"c") = "abc"
assert ("ddac" > "bca") = -1
assert ("dab" = "cd") = 0
assert ("cbdb"+"c") = "cbdbc"
assert ("ad"+"bbcb") = "adbbcb"
assert ("" < "a") = -1
assert ("a"+"dad") = "adad"
assert ("dad" < "d") = 0
assert ("dada"+"bad") = "dadabad"
assert ("ddcd"+"dbd") = "ddcddbd"
assert ("aaa"+"aaad") = "aaaaaad"
assert ("b" <> "d") = -1
assert ("dda" = "d") = 0
assert ("cdc"+"da") = "cdcda"
assert ("b"+"") = "b"
assert ("abb"+"baba") = "abbbaba"
assert ("ccd"+"bacb") = "ccdbacb"
assert ("babc" > "dddd") = 0
assert ("addc" > "baa") = 0
assert ("" <> "") = 0
assert ("aac" >= "aac") = -1
assert ("ac" >= "") = -1
assert ("acab"+"dcd") = "acabdcd"
assert (""+"d") = "d"
assert ("dabc" > "c") = -1
assert ("d" <> "dadb") = -1
assert ("cd" <= "ddc") = -1
assert ("ddbc"+"bba") = "ddbcbba"
assert ("d"+"b") = "db"
assert ("bcc"+"dd") = "bccdd"
assert ("bddc"+"ac") = "bddcac"
assert (""+"d") = "d"
assert ("" <= "cbbb") = -1
assert ("bcda" <> "a") = -1
assert ("bad"+"a") = "bada"
assert ("b"+"d") = "bd"
assert ("bcdd" = "ddcb") = 0
assert ("cab"+"cabc") = "cabcabc"
assert ("b"+"aca") = "baca"
assert ("cd" < "cabc") = 0
assert ("bbab"+"aad") = "bbabaad"
assert ("b"+"d") = "bd"
assert ("ca"+"c") = "cac"
assert ("ddab" = "d") = 0
assert ("d" <= "adad") = 0
assert ("" >= "abad") = 0
assert (""+"bb") = "bb"
assert ("" >= "") = -1
assert ("c"+"d") = "cd"
assert ("ba"+"cd") = "bacd"
assert ("adca"+"bbd") = "adcabbd"
assert ("a" = "db") = 0
assert ("bda"+"b") = "bdab"
assert ("ccab"+"d") = "ccabd"
assert ("cc" = "bdc") = 0
assert ("bcbc" < "cdc") = -1
assert ("bd"+"acab") = "bdacab"
assert ("" <= "cbab") = -1
assert ("d" > "cad") = -1
assert ("aacc" = "baac") = 0
assert ("cbdb" = "da") = 0
assert ("daab"+"d") = "daabd"
assert ("dadb" < "cdca") = 0
assert ("dbb"+"abbd") = "dbbabbd"
assert ("da" >= "aada") = -1
assert ("cb"+"b") = "cbb"
assert ("ccb" = "abc") = 0
assert ("cbab"+"") = "cbab"
assert ("ada" <= "adc") = -1
assert ("cbcd"+"") = "cbcd"
assert ("aad" < "cab") = -1
assert ("cd"+"a") = "cda"
assert ("ddca"+"") = "ddca"
assert ("aadc"+"") = "aadc"
assert ("bc" <> "b") = -1
assert ("a" <= "babd") = -1
assert ("cd" <= "bdd") = 0
assert ("bbd" < "bbbc") = 0
assert ("b" = "ca") = 0
assert ("" > "ba") = 0
assert ("c"+"a") = "ca"
assert ("dccc"+"cdb") = "dccccdb"
assert ("b"+"b") = "bb"
assert ("adc" > "") = -1
assert ("dca" > "dbcd") = -1
assert ("aaa" = "") = 0
assert ("" > "") = 0
assert ("bdc" = "b") = 0
assert ("db"+"") = "db"
assert ("" <= "adb") = -1
assert ("bbc"+"cc") = "bbccc"
assert ("baab" <> "") = -1
assert ("acc"+"aaca") = "accaaca"
assert ("d"+"") = "d"
assert ("c" > "cb") = 0
assert ("ccab" <> "cad") = -1
assert ("bcac"+"bb") = "bcacbb"
assert ("cbad" <= "ac") = 0
assert ("ada" < "ad") = 0
assert ("dd"+"acb") = "ddacb"
xemu
