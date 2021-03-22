;
;	Built using seed 67418
;
assert (""+"a") = "a"
assert ("bcba"+"") = "bcba"
assert ("" > "ba") = 0
assert ("cadc" = "aa") = 0
assert ("cc" < "dcc") = -1
assert ("bbcd" >= "adb") = -1
assert ("ddca"+"baa") = "ddcabaa"
assert ("bcb"+"adcb") = "bcbadcb"
assert ("cb"+"bcac") = "cbbcac"
assert ("a"+"c") = "ac"
assert ("ac" = "") = 0
assert ("ba" <> "dc") = -1
assert ("addd"+"bc") = "adddbc"
assert ("d"+"db") = "ddb"
assert ("bcb" <> "c") = -1
assert ("bda"+"c") = "bdac"
assert ("c" <> "cb") = -1
assert ("d" < "ab") = 0
assert ("a"+"b") = "ab"
assert ("a"+"") = "a"
assert ("d" > "cca") = -1
assert ("a" >= "cdbb") = 0
assert ("cccc"+"dab") = "ccccdab"
assert ("adcc" <> "") = -1
assert ("ccd" >= "") = -1
assert ("ccdd"+"cc") = "ccddcc"
assert ("ddd" >= "") = -1
assert ("adbb" <> "bc") = -1
assert ("dc"+"a") = "dca"
assert ("cdaa" < "") = 0
assert ("bbbb"+"bda") = "bbbbbda"
assert ("" >= "acb") = 0
assert ("bcb" <> "bbd") = -1
assert ("dbdb" <= "") = 0
assert ("baba" < "c") = -1
assert ("dba" <> "bac") = -1
assert ("dba"+"dbd") = "dbadbd"
assert ("dd" < "") = 0
assert ("bda" = "a") = 0
assert ("c" >= "") = -1
assert ("dad" >= "bcad") = -1
assert ("ac" < "b") = -1
assert ("dbac"+"db") = "dbacdb"
assert ("dc" <> "c") = -1
assert ("bbda" <= "dbbb") = -1
assert ("cc" > "cc") = 0
assert (""+"cc") = "cc"
assert ("c" = "") = 0
assert ("da"+"") = "da"
assert (""+"baa") = "baa"
assert ("dc" = "c") = 0
assert ("ac" >= "dc") = 0
assert (""+"ada") = "ada"
assert ("ddc"+"") = "ddc"
assert (""+"") = ""
assert ("adac"+"acd") = "adacacd"
assert ("acc"+"cbca") = "acccbca"
assert (""+"bb") = "bb"
assert ("" = "") = -1
assert ("bcad" <> "abad") = -1
assert ("c" < "bb") = 0
assert ("ddaa" = "") = 0
assert ("bc" >= "") = -1
assert ("" = "") = -1
assert ("bdaa"+"bbcb") = "bdaabbcb"
assert ("aaca"+"aacb") = "aacaaacb"
assert ("dcc"+"dcc") = "dccdcc"
assert ("acda"+"bd") = "acdabd"
assert ("cc" > "adb") = -1
assert ("cccb" >= "bcba") = -1
assert ("cacc" = "a") = 0
assert ("d"+"") = "d"
assert ("c" <> "bcbd") = -1
assert ("a" >= "d") = 0
assert ("d"+"a") = "da"
assert ("badd" > "dcbc") = 0
assert (""+"bdd") = "bdd"
assert ("badc"+"") = "badc"
assert ("ddd"+"b") = "dddb"
assert ("abbd" <= "c") = -1
assert ("cbc"+"cd") = "cbccd"
assert ("b"+"daad") = "bdaad"
assert ("daac"+"") = "daac"
assert ("dbad"+"") = "dbad"
assert ("aacd" = "ddd") = 0
assert ("" > "d") = 0
assert ("" >= "d") = 0
assert ("cb" <> "aa") = -1
assert ("b"+"d") = "bd"
assert ("b" = "") = 0
assert ("a"+"dba") = "adba"
assert ("bd"+"c") = "bdc"
assert (""+"") = ""
assert ("baa" <> "dba") = -1
assert ("a"+"db") = "adb"
assert ("b"+"ddca") = "bddca"
assert ("bcad"+"bbd") = "bcadbbd"
assert ("daa" >= "cd") = -1
assert ("a" > "bbd") = 0
assert ("" <> "cbb") = -1
assert ("" < "aada") = -1
assert ("d"+"") = "d"
assert ("dbdd"+"dd") = "dbdddd"
assert ("aaad"+"cba") = "aaadcba"
assert ("" = "cd") = 0
assert ("a" < "adba") = -1
assert ("ccac" < "") = 0
assert ("caa" = "aacc") = 0
assert ("add"+"db") = "adddb"
assert ("c" > "ccad") = 0
assert ("cdca" >= "db") = 0
assert (""+"cd") = "cd"
assert ("cd"+"ac") = "cdac"
assert ("cddb" <= "") = 0
assert ("dadd"+"") = "dadd"
assert ("aa"+"bcb") = "aabcb"
assert (""+"ddd") = "ddd"
assert (""+"d") = "d"
assert ("ad" < "ca") = -1
assert ("dcd"+"d") = "dcdd"
assert ("" = "caa") = 0
assert ("ddd"+"bdb") = "dddbdb"
assert ("cb" >= "dccb") = 0
assert ("dd" < "b") = 0
assert ("dbaa"+"cba") = "dbaacba"
assert ("dcbc"+"c") = "dcbcc"
assert ("c"+"aba") = "caba"
assert (""+"dd") = "dd"
assert ("a"+"ca") = "aca"
assert ("abd" <= "d") = -1
assert ("aa" >= "") = -1
assert ("dac" > "a") = -1
assert ("c"+"cadd") = "ccadd"
assert ("cb" = "aab") = 0
assert ("ca"+"babc") = "cababc"
assert ("d" < "d") = 0
assert (""+"cb") = "cb"
assert ("dbc"+"aba") = "dbcaba"
assert ("" <= "baaa") = -1
assert ("cba" > "cb") = -1
assert ("db" <> "bbb") = -1
assert ("bda" <= "") = 0
assert ("" <= "ab") = -1
assert ("" >= "bad") = 0
assert ("ab" <= "bbbb") = -1
assert ("b"+"b") = "bb"
assert ("acd"+"bdbd") = "acdbdbd"
assert ("bba"+"b") = "bbab"
assert ("ddb"+"bb") = "ddbbb"
assert ("aad" < "ca") = -1
assert ("" >= "d") = 0
assert ("ca" <> "dcdc") = -1
assert ("" < "b") = -1
assert ("cc" > "c") = -1
assert ("b"+"") = "b"
assert ("baad" = "ca") = 0
assert ("cad" > "abca") = -1
assert ("dad"+"") = "dad"
assert ("aaca" > "ca") = 0
assert ("aa"+"") = "aa"
assert (""+"") = ""
assert ("adad"+"b") = "adadb"
assert ("ab" <= "bd") = -1
assert ("c" <= "ab") = 0
assert ("aadd" > "b") = 0
assert ("c" >= "") = -1
assert ("bbcc"+"ba") = "bbccba"
assert ("" = "") = -1
assert (""+"b") = "b"
assert ("" >= "aaca") = 0
assert ("cb" < "") = 0
assert ("ddd" <> "c") = -1
assert ("c"+"") = "c"
assert ("ac"+"") = "ac"
assert ("d"+"") = "d"
assert ("ba" > "") = -1
assert ("dba" < "b") = 0
assert ("daaa" <= "") = 0
assert ("cc"+"dddd") = "ccdddd"
assert ("cca" <= "ba") = 0
assert (""+"d") = "d"
assert ("bd"+"cacb") = "bdcacb"
assert ("db" > "") = -1
assert ("ca" <> "b") = -1
assert ("ad"+"d") = "add"
assert ("ac"+"c") = "acc"
assert ("aad" > "bbc") = 0
assert ("ac" <= "bc") = -1
assert ("" <> "") = 0
assert (""+"") = ""
assert ("d"+"cdab") = "dcdab"
assert ("add"+"a") = "adda"
assert ("a" <> "cd") = -1
assert ("" < "a") = -1
assert ("ac" >= "") = -1
assert ("c" <= "c") = -1
assert ("cd" <> "cc") = -1
assert ("ccaa" = "b") = 0
assert ("a"+"aaba") = "aaaba"
assert ("bcd"+"b") = "bcdb"
assert ("dbc"+"ca") = "dbcca"
assert ("a"+"dd") = "add"
assert ("c"+"b") = "cb"
assert ("ca" < "cb") = -1
assert ("cb"+"abbb") = "cbabbb"
assert ("da"+"") = "da"
assert ("a"+"a") = "aa"
assert ("d" > "") = -1
assert ("abc" = "") = 0
assert ("cab"+"ccbb") = "cabccbb"
assert ("cc"+"a") = "cca"
assert ("ba" > "cd") = 0
assert ("" >= "cdc") = 0
assert ("abdc"+"bbcc") = "abdcbbcc"
assert ("" <= "adc") = -1
assert ("c" < "dda") = -1
assert (""+"c") = "c"
assert ("cca"+"") = "cca"
assert ("a"+"cadc") = "acadc"
assert ("d" > "") = -1
assert ("adab" < "") = 0
assert ("aaaa"+"cacb") = "aaaacacb"
assert ("adb" >= "bd") = 0
assert ("ad"+"abd") = "adabd"
assert (""+"cc") = "cc"
assert ("bdbd" <= "") = 0
assert ("aa"+"a") = "aaa"
assert ("abca"+"b") = "abcab"
assert ("b" >= "bdac") = 0
assert (""+"bbca") = "bbca"
assert ("cabd" <= "b") = 0
assert ("adc"+"b") = "adcb"
assert ("ada"+"") = "ada"
assert ("a" <> "ab") = -1
assert ("ccc" < "") = 0
assert ("cbac"+"") = "cbac"
assert (""+"accd") = "accd"
assert ("bdad"+"") = "bdad"
assert ("c" < "c") = 0
assert ("ab"+"daca") = "abdaca"
assert ("db"+"") = "db"
assert ("acc"+"cb") = "acccb"
assert ("a"+"d") = "ad"
assert ("adab"+"dbda") = "adabdbda"
assert ("dd"+"dc") = "dddc"
assert ("" <> "c") = -1
assert ("a"+"") = "a"
assert ("" > "cab") = 0
assert (""+"b") = "b"
assert ("" = "abbd") = 0
assert ("a" = "a") = -1
assert ("dbbb" < "b") = 0
assert ("abcb" <= "") = 0
assert ("dbd"+"bbb") = "dbdbbb"
assert (""+"c") = "c"
assert ("ddbd"+"db") = "ddbddb"
assert ("bdd"+"d") = "bddd"
assert ("ac" >= "") = -1
assert ("aa" >= "a") = -1
assert ("addd" > "bb") = 0
assert (""+"aaac") = "aaac"
assert ("da"+"") = "da"
assert ("a" > "cc") = 0
assert ("ab" <= "b") = -1
assert ("b"+"ad") = "bad"
assert ("bcca"+"b") = "bccab"
assert ("a"+"acd") = "aacd"
assert ("a" < "") = 0
assert ("aadc"+"c") = "aadcc"
assert ("" >= "d") = 0
assert ("ccc"+"cab") = "ccccab"
assert ("cbc" > "bc") = -1
assert ("" >= "") = -1
assert ("c"+"") = "c"
assert (""+"dd") = "dd"
assert ("bda"+"bdda") = "bdabdda"
assert ("cbb"+"ad") = "cbbad"
assert ("d"+"cb") = "dcb"
assert ("bb"+"ccc") = "bbccc"
assert ("b"+"a") = "ba"
assert ("b" >= "abd") = -1
assert ("" <> "ad") = -1
assert ("aa"+"") = "aa"
assert ("ad" = "dad") = 0
assert ("aa" <> "dac") = -1
assert (""+"dbdd") = "dbdd"
assert ("" > "") = 0
assert (""+"") = ""
assert ("dcbd"+"abac") = "dcbdabac"
assert (""+"dadb") = "dadb"
assert ("bca" > "c") = 0
assert ("acb" <= "abb") = 0
assert ("ccb"+"") = "ccb"
assert ("dadb"+"ca") = "dadbca"
assert ("a" <> "bcd") = -1
assert ("" >= "dbdd") = 0
assert ("cbd"+"bbdd") = "cbdbbdd"
assert ("dbc" <= "abc") = 0
assert ("aca"+"ddbd") = "acaddbd"
assert (""+"") = ""
assert ("a" > "b") = 0
assert ("cb" > "") = -1
assert ("aba"+"b") = "abab"
assert ("cadb" <> "ac") = -1
assert ("d" <= "adb") = 0
assert ("cdbd"+"cb") = "cdbdcb"
assert ("aaa" >= "daab") = 0
assert ("da"+"ba") = "daba"
assert ("cbdd" > "") = -1
assert ("ddb" = "") = 0
assert (""+"cdb") = "cdb"
assert ("bbcc" <= "") = 0
assert ("" = "ac") = 0
assert ("bbcb" >= "aa") = -1
assert ("bbdc" > "bcb") = 0
assert ("cac"+"dcbb") = "cacdcbb"
assert ("db"+"bccc") = "dbbccc"
assert ("c" < "") = 0
assert ("a" = "bdad") = 0
assert (""+"b") = "b"
assert ("c"+"") = "c"
assert ("" = "bbb") = 0
assert ("b"+"cdd") = "bcdd"
assert ("" < "") = 0
assert ("cdc"+"ccd") = "cdcccd"
assert ("b"+"c") = "bc"
assert ("dcbc" <> "") = -1
assert ("c" >= "cdd") = 0
assert ("cd" > "dd") = 0
assert ("d"+"bbb") = "dbbb"
assert ("bd" > "cab") = 0
assert ("bba" >= "b") = -1
assert ("" >= "ccbb") = 0
assert ("aadb"+"cdd") = "aadbcdd"
assert ("dcb" < "") = 0
assert ("cbb" < "dda") = -1
assert ("dbc"+"") = "dbc"
assert ("adda"+"") = "adda"
assert ("c" <> "") = -1
assert ("d"+"dd") = "ddd"
assert ("a"+"adad") = "aadad"
assert ("d"+"c") = "dc"
assert ("c" < "c") = 0
assert ("ba"+"") = "ba"
assert (""+"bbcd") = "bbcd"
assert ("cbcb"+"bb") = "cbcbbb"
assert (""+"") = ""
assert ("b"+"") = "b"
assert ("cc" >= "d") = 0
assert ("cab" <= "b") = 0
assert ("cbab"+"abbd") = "cbababbd"
assert ("a"+"bc") = "abc"
assert ("cab"+"add") = "cabadd"
assert ("d" <= "") = 0
assert ("aa" <= "dca") = -1
assert ("" <> "caad") = -1
assert ("aca"+"d") = "acad"
assert ("dcc"+"a") = "dcca"
assert ("cb"+"ab") = "cbab"
assert ("aa" < "da") = -1
assert ("ccab"+"db") = "ccabdb"
assert ("ccc"+"d") = "cccd"
assert ("db"+"") = "db"
assert ("ac" < "") = 0
assert (""+"aac") = "aac"
assert ("ccac"+"bad") = "ccacbad"
assert (""+"b") = "b"
assert (""+"aaad") = "aaad"
assert ("acd"+"ca") = "acdca"
assert ("dc" >= "abb") = -1
assert ("db"+"acaa") = "dbacaa"
assert ("aaab" <= "dc") = -1
assert ("bbbb"+"dc") = "bbbbdc"
assert (""+"d") = "d"
assert ("a" = "dbcb") = 0
assert ("" > "aba") = 0
assert ("" <> "d") = -1
assert (""+"") = ""
assert (""+"") = ""
assert ("bad" > "cca") = 0
assert ("a"+"acc") = "aacc"
assert (""+"bb") = "bb"
assert ("b" <> "") = -1
assert ("dbbb"+"") = "dbbb"
assert ("ab"+"ca") = "abca"
assert ("bd" <> "dbd") = -1
assert ("d"+"dbab") = "ddbab"
assert ("d"+"") = "d"
assert ("dada"+"a") = "dadaa"
assert ("c"+"cdab") = "ccdab"
assert ("bb" < "da") = -1
assert ("cd"+"") = "cd"
assert ("cac" < "dabb") = -1
assert ("" < "cd") = -1
assert ("" <> "ad") = -1
assert ("d" > "a") = -1
assert ("c"+"dbbc") = "cdbbc"
assert ("dcad"+"dcc") = "dcaddcc"
assert ("caaa"+"abcc") = "caaaabcc"
assert ("cabd" >= "ab") = -1
assert ("bdb" <> "b") = -1
assert ("bcb"+"") = "bcb"
assert ("bccc"+"b") = "bcccb"
assert ("ada"+"cbd") = "adacbd"
assert ("bbdb"+"b") = "bbdbb"
assert ("a" <= "adbd") = -1
assert ("" < "bdab") = -1
assert ("ada"+"da") = "adada"
assert ("adac"+"abbb") = "adacabbb"
assert ("ccdd" <= "ba") = 0
assert ("ca" > "aa") = -1
assert ("ba" > "ccac") = 0
assert (""+"db") = "db"
assert ("cd" < "ca") = 0
assert ("d" >= "") = -1
assert ("dbc"+"dd") = "dbcdd"
assert ("acbb" = "bab") = 0
assert ("b" > "bac") = 0
assert ("da" > "acc") = -1
assert ("" > "adbd") = 0
assert ("dab" <> "cda") = -1
assert ("bc"+"aabb") = "bcaabb"
assert ("" <> "") = 0
assert ("bcb"+"") = "bcb"
assert ("aa" < "") = 0
assert ("da" < "") = 0
assert ("abab"+"caa") = "ababcaa"
assert ("dbcb"+"adc") = "dbcbadc"
assert ("bcba"+"cdb") = "bcbacdb"
assert ("adcb" > "") = -1
assert (""+"aca") = "aca"
assert ("bd"+"db") = "bddb"
assert ("ad"+"bcb") = "adbcb"
assert ("aa" = "cdd") = 0
assert ("b"+"dbaa") = "bdbaa"
assert ("abd"+"dcd") = "abddcd"
assert ("b"+"") = "b"
assert ("ddda" <> "c") = -1
assert ("bbda" > "") = -1
assert ("" <> "cc") = -1
assert ("ab"+"db") = "abdb"
assert ("bc"+"d") = "bcd"
assert ("" < "abad") = -1
assert (""+"d") = "d"
assert ("caad" < "") = 0
assert ("cd"+"b") = "cdb"
assert ("c"+"a") = "ca"
assert (""+"ca") = "ca"
assert ("dacd"+"cd") = "dacdcd"
assert ("" = "") = -1
assert ("abad"+"b") = "abadb"
assert ("bbb"+"") = "bbb"
assert ("cbd" <= "caa") = 0
assert ("" > "d") = 0
assert ("cba"+"b") = "cbab"
assert ("dcdb" > "aa") = -1
assert ("a" <= "dca") = -1
assert ("" <> "") = 0
assert ("caa" <= "dabc") = -1
assert ("dad"+"dba") = "daddba"
assert ("aa"+"bd") = "aabd"
assert ("" < "ca") = -1
assert ("aaa"+"cad") = "aaacad"
assert ("dda"+"d") = "ddad"
assert ("bab" >= "d") = 0
assert (""+"da") = "da"
assert ("ab"+"bda") = "abbda"
assert ("acda" <> "d") = -1
assert ("bd" <> "a") = -1
assert ("c"+"dbbb") = "cdbbb"
assert ("ada" <= "ab") = 0
assert (""+"cb") = "cb"
assert ("b" <= "") = 0
assert ("" <= "c") = -1
assert ("a"+"abb") = "aabb"
assert ("bbac" > "aa") = -1
assert ("cdac"+"bdda") = "cdacbdda"
assert ("bcc" < "cdc") = -1
assert ("dc" <= "") = 0
assert ("dbc" < "cd") = 0
assert ("" >= "acbd") = 0
assert ("b" >= "b") = -1
assert ("cbdb" <> "") = -1
assert ("" <= "cd") = -1
assert ("d"+"acda") = "dacda"
assert ("d" <> "ac") = -1
assert (""+"dc") = "dc"
assert ("" > "b") = 0
assert ("ad"+"baca") = "adbaca"
assert ("ccca" >= "bbb") = -1
assert ("ba"+"cada") = "bacada"
assert ("bdb" = "bbc") = 0
assert ("" <> "") = 0
assert ("" > "cbdc") = 0
assert ("adac" <= "") = 0
assert ("a"+"caad") = "acaad"
assert ("cc"+"") = "cc"
assert ("d"+"cb") = "dcb"
assert ("bcab" = "") = 0
assert (""+"ac") = "ac"
xemu
