;
;	Built using seed 29340
;
assert ("aa"+"dcda") = "aadcda"
assert ("ada"+"ddcb") = "adaddcb"
assert ("a" <= "") = 0
assert ("d" <= "") = 0
assert ("da" < "") = 0
assert ("bda"+"") = "bda"
assert ("dddd"+"abd") = "ddddabd"
assert ("bbcc"+"bdb") = "bbccbdb"
assert ("bbbb"+"") = "bbbb"
assert ("" <= "d") = -1
assert (""+"ca") = "ca"
assert ("ddd"+"bc") = "dddbc"
assert ("b" = "") = 0
assert ("ddad" < "dcc") = 0
assert ("bc"+"dc") = "bcdc"
assert ("bbb"+"adac") = "bbbadac"
assert ("bd"+"cd") = "bdcd"
assert ("cac" > "") = -1
assert ("cc"+"cd") = "cccd"
assert ("acc"+"d") = "accd"
assert ("aa"+"ac") = "aaac"
assert ("bdad"+"dc") = "bdaddc"
assert ("dad" <= "adda") = 0
assert ("cbcc" <= "ab") = 0
assert ("adb"+"dbc") = "adbdbc"
assert ("cccd"+"ccbd") = "cccdccbd"
assert ("acda" > "") = -1
assert (""+"da") = "da"
assert ("cad"+"ac") = "cadac"
assert (""+"caab") = "caab"
assert ("cb" >= "acc") = -1
assert (""+"dda") = "dda"
assert ("acd"+"aaca") = "acdaaca"
assert ("dcdc"+"caaa") = "dcdccaaa"
assert ("ac"+"bcbb") = "acbcbb"
assert ("ccc"+"d") = "cccd"
assert ("cdd" = "ca") = 0
assert ("" >= "ddc") = 0
assert ("" > "bcd") = 0
assert ("accc"+"") = "accc"
assert ("bdcd"+"cc") = "bdcdcc"
assert ("a" <= "") = 0
assert ("badd" = "") = 0
assert ("d" >= "bca") = -1
assert ("cc" <= "aa") = 0
assert ("ddcb"+"") = "ddcb"
assert ("bbd"+"") = "bbd"
assert ("daca" <= "") = 0
assert ("" <> "bba") = -1
assert ("b" < "aac") = 0
assert ("" < "a") = -1
assert ("ca" <= "bc") = 0
assert ("aca" <= "b") = -1
assert ("ada"+"") = "ada"
assert ("cc" < "adaa") = 0
assert ("ac" = "") = 0
assert ("" >= "cbdc") = 0
assert ("ab"+"daac") = "abdaac"
assert (""+"bd") = "bd"
assert ("bbcc" >= "dbd") = 0
assert ("c"+"ca") = "cca"
assert ("aa" <= "") = 0
assert (""+"aab") = "aab"
assert ("bac" <> "d") = -1
assert ("bc"+"bc") = "bcbc"
assert ("d" <> "cbbd") = -1
assert ("bb" < "d") = -1
assert ("cc"+"dd") = "ccdd"
assert ("ad" <> "dcd") = -1
assert ("badc"+"cdda") = "badccdda"
assert ("" >= "a") = 0
assert ("b"+"cadb") = "bcadb"
assert ("cdb" >= "") = -1
assert (""+"ca") = "ca"
assert ("bca" < "a") = 0
assert ("a"+"cccd") = "acccd"
assert ("a" >= "abcc") = 0
assert ("daad" > "cbdb") = -1
assert ("add"+"cb") = "addcb"
assert ("d" < "") = 0
assert ("ca" > "bc") = -1
assert (""+"bbbb") = "bbbb"
assert ("bbcd"+"") = "bbcd"
assert ("aa" > "b") = 0
assert ("c"+"dbc") = "cdbc"
assert ("ab" < "") = 0
assert ("cbb" = "dabb") = 0
assert ("adb"+"") = "adb"
assert ("b" > "") = -1
assert (""+"b") = "b"
assert ("bb" >= "bdb") = 0
assert ("" < "bcad") = -1
assert ("bc"+"dd") = "bcdd"
assert (""+"") = ""
assert ("ccbb" > "bcdd") = -1
assert ("adbc" < "") = 0
assert ("bcb"+"cac") = "bcbcac"
assert ("dacb" < "cdbb") = 0
assert ("ada" = "cbd") = 0
assert (""+"bdbb") = "bdbb"
assert ("aa"+"a") = "aaa"
assert ("b" <> "baaa") = -1
assert ("cd" < "cb") = 0
assert ("bcbb" <> "cbb") = -1
assert ("bcb" < "bccb") = -1
assert ("dbcd"+"") = "dbcd"
assert ("cc" = "ccbd") = 0
assert ("cadd" = "c") = 0
assert ("a"+"") = "a"
assert ("da"+"c") = "dac"
assert ("dbcc"+"cadc") = "dbcccadc"
assert ("d" = "d") = -1
assert ("d"+"") = "d"
assert ("cbc"+"c") = "cbcc"
assert ("bc" < "") = 0
assert ("dc"+"ddcb") = "dcddcb"
assert ("bddb"+"cbcc") = "bddbcbcc"
assert (""+"b") = "b"
assert (""+"dc") = "dc"
assert ("bba"+"") = "bba"
assert ("a" < "c") = -1
assert ("c"+"a") = "ca"
assert ("" < "dbb") = -1
assert ("" <= "ccb") = -1
assert ("ab" <> "dcb") = -1
assert ("dcd"+"bbd") = "dcdbbd"
assert ("b"+"cada") = "bcada"
assert ("cbd" >= "babd") = -1
assert (""+"cc") = "cc"
assert ("ab"+"") = "ab"
assert ("" < "aaba") = -1
assert ("dbda" > "d") = -1
assert ("acbc"+"bad") = "acbcbad"
assert ("" > "adb") = 0
assert ("cdaa" < "d") = -1
assert ("bc"+"ba") = "bcba"
assert (""+"ccd") = "ccd"
assert ("c" < "cd") = -1
assert ("dba"+"") = "dba"
assert ("bacb"+"") = "bacb"
assert ("abbc" < "add") = -1
assert ("d"+"daa") = "ddaa"
assert ("cdd"+"dbc") = "cdddbc"
assert ("d" > "d") = 0
assert (""+"abb") = "abb"
assert ("cd" = "b") = 0
assert ("abac" > "") = -1
assert ("bc" <> "") = -1
assert ("" < "d") = -1
assert ("b" >= "baba") = 0
assert ("dc" >= "a") = -1
assert ("db"+"cb") = "dbcb"
assert (""+"dbcd") = "dbcd"
assert ("dada"+"aba") = "dadaaba"
assert (""+"") = ""
assert ("dab"+"dbc") = "dabdbc"
assert ("c" < "") = 0
assert ("cbc"+"daa") = "cbcdaa"
assert ("cd" <> "dbca") = -1
assert ("b" < "") = 0
assert ("dc"+"") = "dc"
assert ("a"+"cb") = "acb"
assert (""+"b") = "b"
assert ("a" > "cba") = 0
assert ("ab"+"db") = "abdb"
assert ("dc" > "bac") = -1
assert ("add"+"dbdb") = "adddbdb"
assert (""+"") = ""
assert ("cb" <> "") = -1
assert ("c"+"caad") = "ccaad"
assert ("bcbd"+"bdbc") = "bcbdbdbc"
assert ("a"+"cdcd") = "acdcd"
assert ("bbc" >= "da") = 0
assert ("c"+"bbbd") = "cbbbd"
assert ("aa"+"aa") = "aaaa"
assert ("daba"+"") = "daba"
assert ("d" <= "dbd") = -1
assert ("bdaa" < "a") = 0
assert (""+"cabd") = "cabd"
assert ("a" > "cd") = 0
assert ("bdb"+"cbb") = "bdbcbb"
assert ("c"+"bab") = "cbab"
assert ("aa" <> "cd") = -1
assert ("dcad"+"b") = "dcadb"
assert ("dcab"+"dda") = "dcabdda"
assert ("" <= "baca") = -1
assert ("b"+"baa") = "bbaa"
assert ("bd" < "ba") = 0
assert ("c"+"bbda") = "cbbda"
assert ("b" <> "aca") = -1
assert ("a"+"") = "a"
assert ("" <= "babd") = -1
assert ("dbc"+"") = "dbc"
assert ("ca" <= "") = 0
assert ("b" >= "") = -1
assert ("c" > "") = -1
assert ("dcbd" > "b") = -1
assert ("aab" < "") = 0
assert ("abaa" <= "cb") = -1
assert ("" <= "ba") = -1
assert ("adaa" = "") = 0
assert ("bbcb"+"caa") = "bbcbcaa"
assert ("ab"+"bddb") = "abbddb"
assert ("bc" > "") = -1
assert ("dbad"+"bdc") = "dbadbdc"
assert ("ddac"+"aa") = "ddacaa"
assert ("" <= "baa") = -1
assert ("a" >= "ccad") = 0
assert ("" <= "") = -1
assert ("adb" >= "d") = 0
assert ("adcc"+"") = "adcc"
assert ("" <= "") = -1
assert ("c"+"bba") = "cbba"
assert ("bbcc"+"abb") = "bbccabb"
assert ("aab" = "ddc") = 0
assert ("bd"+"") = "bd"
assert ("adac" >= "dcdc") = 0
assert (""+"cdc") = "cdc"
assert ("b" >= "aab") = -1
assert ("cc" = "bb") = 0
assert (""+"db") = "db"
assert (""+"cd") = "cd"
assert ("c"+"abc") = "cabc"
assert (""+"adcd") = "adcd"
assert ("bdba"+"bcbc") = "bdbabcbc"
assert ("bba"+"") = "bba"
assert ("" > "dbcb") = 0
assert ("d" < "adb") = 0
assert ("dcaa" < "c") = 0
assert ("acab" >= "aaaa") = -1
assert ("" < "bd") = -1
assert ("cdcc"+"") = "cdcc"
assert ("" = "b") = 0
assert ("" = "b") = 0
assert ("" <> "") = 0
assert ("cc" >= "") = -1
assert ("bdda" > "cbcd") = 0
assert ("bccd" < "bdb") = -1
assert ("d"+"d") = "dd"
assert ("aca" <= "db") = -1
assert ("cb"+"cbcc") = "cbcbcc"
assert ("bca" <= "adbb") = 0
assert ("c" = "cd") = 0
assert ("d"+"") = "d"
assert ("daad" > "bbba") = -1
assert ("c" > "") = -1
assert ("dbba"+"addd") = "dbbaaddd"
assert ("a" > "bb") = 0
assert (""+"bba") = "bba"
assert ("dddd"+"daac") = "dddddaac"
assert (""+"abd") = "abd"
assert ("cdb" >= "") = -1
assert (""+"b") = "b"
assert ("bc" >= "bac") = -1
assert ("cbcc"+"ddbc") = "cbccddbc"
assert ("" > "c") = 0
assert (""+"ba") = "ba"
assert ("dada"+"bbdb") = "dadabbdb"
assert (""+"adbb") = "adbb"
assert ("" > "") = 0
assert ("ddca" >= "") = -1
assert ("b" <> "cda") = -1
assert ("" >= "dd") = 0
assert ("aa" >= "abaa") = 0
assert ("cccd"+"cdd") = "cccdcdd"
assert ("bab"+"adbb") = "babadbb"
assert ("c" <> "bad") = -1
assert ("bdb" <= "ddc") = -1
assert ("aadb" <= "da") = -1
assert ("acdc" > "d") = 0
assert ("d" >= "d") = -1
assert ("cd"+"d") = "cdd"
assert ("b" = "bd") = 0
assert ("a" <= "") = 0
assert ("" <> "b") = -1
assert ("ccc"+"bb") = "cccbb"
assert ("aaa" <> "a") = -1
assert ("b"+"ca") = "bca"
assert ("a" <> "") = -1
assert ("cc" = "d") = 0
assert ("" = "baad") = 0
assert ("ccbd"+"dc") = "ccbddc"
assert ("cca" = "aca") = 0
assert ("" = "d") = 0
assert ("ccbd" = "d") = 0
assert ("" = "cda") = 0
assert ("dcbb" < "aabd") = 0
assert ("cc" > "") = -1
assert ("dc"+"c") = "dcc"
assert ("aca"+"") = "aca"
assert ("cb"+"dcb") = "cbdcb"
assert ("aa"+"c") = "aac"
assert ("cacd" = "cca") = 0
assert ("bd"+"c") = "bdc"
assert ("d"+"") = "d"
assert ("bd"+"") = "bd"
assert (""+"a") = "a"
assert ("dac" = "b") = 0
assert ("dbac" >= "d") = -1
assert ("abb" <> "d") = -1
assert ("ba"+"") = "ba"
assert ("bc" >= "bdd") = 0
assert ("bda"+"") = "bda"
assert ("bc" = "bad") = 0
assert ("c"+"") = "c"
assert ("bac" < "") = 0
assert ("ad" = "ab") = 0
assert ("" < "c") = -1
assert ("" <> "cdd") = -1
assert ("bb" >= "ddcc") = 0
assert ("a"+"ba") = "aba"
assert ("" = "c") = 0
assert ("cabc" < "a") = 0
assert ("dacc" = "abb") = 0
assert ("bddb" <> "aacc") = -1
assert ("b"+"bada") = "bbada"
assert ("bdad" = "") = 0
assert ("cab" = "ca") = 0
assert ("dcb" <= "bb") = 0
assert ("a" > "c") = 0
assert ("dc"+"c") = "dcc"
assert ("d" <= "cb") = 0
assert ("b" = "adad") = 0
assert ("" = "d") = 0
assert ("a"+"adb") = "aadb"
assert (""+"ccd") = "ccd"
assert ("addc" > "aaca") = -1
assert ("dc"+"") = "dc"
assert ("add"+"add") = "addadd"
assert ("daab" < "dbdc") = -1
assert ("dc" < "bdd") = 0
assert ("dabd" < "a") = 0
assert (""+"") = ""
assert ("a"+"aab") = "aaab"
assert ("cc"+"ac") = "ccac"
assert ("ac" >= "ba") = 0
assert ("bca"+"aa") = "bcaaa"
assert ("aaca"+"cdd") = "aacacdd"
assert ("db" < "") = 0
assert ("bba" < "bcd") = -1
assert ("cc" < "cbad") = 0
assert ("dc" <= "adc") = 0
assert ("bdbb" < "") = 0
assert ("a"+"cca") = "acca"
assert ("b" = "b") = -1
assert ("dc" > "") = -1
assert ("ccbd" < "") = 0
assert ("c" <> "cacd") = -1
assert ("abb"+"") = "abb"
assert ("bbbb"+"") = "bbbb"
assert ("c"+"d") = "cd"
assert ("daac"+"ad") = "daacad"
assert ("bdc" < "") = 0
assert (""+"c") = "c"
assert (""+"abcb") = "abcb"
assert (""+"bd") = "bd"
assert ("dad" <= "acd") = 0
assert (""+"abd") = "abd"
assert ("cdc"+"d") = "cdcd"
assert ("bbbc"+"adad") = "bbbcadad"
assert (""+"ac") = "ac"
assert (""+"dca") = "dca"
assert ("" <= "add") = -1
assert ("b"+"") = "b"
assert (""+"bc") = "bc"
assert ("abc" >= "caac") = 0
assert ("db" <> "") = -1
assert ("a"+"da") = "ada"
assert ("db"+"c") = "dbc"
assert ("aadd"+"") = "aadd"
assert ("" > "a") = 0
assert ("cd" > "") = -1
assert ("" > "ddca") = 0
assert ("" <> "db") = -1
assert ("bbbc"+"cc") = "bbbccc"
assert ("db"+"dbb") = "dbdbb"
assert ("aad"+"cbab") = "aadcbab"
assert (""+"cda") = "cda"
assert ("cca"+"") = "cca"
assert (""+"d") = "d"
assert ("" < "") = 0
assert ("cc" <= "a") = 0
assert ("" > "ad") = 0
assert ("cd" <= "") = 0
assert ("c"+"cacc") = "ccacc"
assert ("" >= "b") = 0
assert ("cd"+"a") = "cda"
assert ("ba" > "cdd") = 0
assert ("bcdb"+"dbad") = "bcdbdbad"
assert ("bd"+"caba") = "bdcaba"
assert ("d" < "c") = 0
assert (""+"ab") = "ab"
assert ("db"+"adab") = "dbadab"
assert ("cdca"+"baaa") = "cdcabaaa"
assert ("d"+"") = "d"
assert ("dbdc"+"cd") = "dbdccd"
assert ("acbb"+"bbda") = "acbbbbda"
assert ("bdad" < "bdd") = -1
assert ("daba"+"") = "daba"
assert (""+"bd") = "bd"
assert ("aad"+"caca") = "aadcaca"
assert ("d" < "ddcd") = -1
assert ("aadd"+"a") = "aadda"
assert ("a"+"babc") = "ababc"
assert ("b"+"") = "b"
assert ("" < "accd") = -1
assert ("aa" >= "cc") = 0
assert ("bdac"+"bbbd") = "bdacbbbd"
assert ("accc" >= "") = -1
assert ("abd"+"c") = "abdc"
assert (""+"a") = "a"
assert ("ab" = "ac") = 0
assert ("dd"+"bda") = "ddbda"
assert ("caba"+"bac") = "cababac"
assert ("cb" >= "") = -1
assert ("" = "d") = 0
assert (""+"") = ""
assert ("" < "dbb") = -1
assert ("babd" <= "a") = 0
assert ("b" >= "") = -1
assert ("accd" <= "dcb") = -1
assert ("ad" <= "db") = -1
assert ("dba" > "") = -1
assert ("a"+"d") = "ad"
assert ("bdc"+"bb") = "bdcbb"
assert ("" < "cc") = -1
assert ("c"+"aca") = "caca"
assert ("d" = "aaa") = 0
assert ("bdb"+"aab") = "bdbaab"
assert (""+"") = ""
assert ("" <> "bccc") = -1
assert (""+"da") = "da"
assert ("cd"+"") = "cd"
assert ("cddc"+"ad") = "cddcad"
assert ("bdd" > "ad") = -1
assert ("dca" <> "bda") = -1
assert ("cbb"+"d") = "cbbd"
assert ("c" >= "cbca") = 0
assert ("cb"+"baca") = "cbbaca"
assert ("ddca" > "bb") = -1
assert ("b" < "") = 0
assert ("ba" <= "") = 0
assert ("a" < "cccd") = -1
assert (""+"cdb") = "cdb"
assert ("dd" <= "bbbd") = 0
assert ("cb" = "abba") = 0
assert ("d"+"d") = "dd"
assert ("aaaa"+"dcaa") = "aaaadcaa"
assert ("d" <> "") = -1
assert ("aaa"+"") = "aaa"
assert ("db" = "ab") = 0
assert ("da" >= "c") = -1
assert ("d"+"bba") = "dbba"
assert ("cdac"+"b") = "cdacb"
assert ("cbc" = "db") = 0
assert ("cdd" > "cdb") = -1
assert ("c"+"") = "c"
assert ("add" >= "cd") = 0
assert ("bd" > "bca") = -1
assert ("abcc"+"add") = "abccadd"
assert ("abbc" > "cdac") = 0
assert ("ba"+"abd") = "baabd"
assert ("ddca"+"bcab") = "ddcabcab"
assert ("" <= "") = -1
assert ("" <= "") = -1
assert ("cdcc"+"dcbd") = "cdccdcbd"
assert (""+"") = ""
assert ("cdcc"+"") = "cdcc"
assert ("ca"+"dcb") = "cadcb"
assert ("ccad"+"cba") = "ccadcba"
assert ("dc" <> "") = -1
assert (""+"da") = "da"
assert ("cad" > "acb") = -1
assert ("da" > "") = -1
assert ("ca"+"ab") = "caab"
assert ("acc" < "aaa") = 0
assert ("a" <> "d") = -1
assert ("cccc"+"cadc") = "cccccadc"
assert ("ad" < "d") = -1
assert ("" > "adab") = 0
assert ("a"+"bd") = "abd"
assert (""+"bac") = "bac"
assert ("dac"+"c") = "dacc"
assert ("aba"+"") = "aba"
assert ("bada"+"dd") = "badadd"
assert ("dbd"+"d") = "dbdd"
assert ("dab"+"ccbd") = "dabccbd"
assert ("adcc" < "") = 0
assert (""+"bcd") = "bcd"
assert ("dbac" = "c") = 0
assert ("" <= "") = -1
assert (""+"") = ""
assert ("cd" > "") = -1
assert ("cbac"+"cd") = "cbaccd"
assert ("c"+"acc") = "cacc"
assert ("cdc"+"dcb") = "cdcdcb"
assert ("bca" <= "b") = 0
assert ("a"+"bca") = "abca"
assert ("cd"+"acc") = "cdacc"
assert ("cb" > "") = -1
xemu
