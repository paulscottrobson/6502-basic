pushd ../scripts
python builder.py
popd
64tass -c -L basic.lst -l basic.lbl -o basic.prg basic.asm	