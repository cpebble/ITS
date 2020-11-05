#!/bin/bash
ciphs=(ecb cbc cfb ofb)
K=00112233445566778899aabbccddeeff
IV=0102030405060708
for ciph in ${ciphs[@]}; 
do 
    echo "Encrypting $ciph"
    openssl enc -aes-128-$ciph -in document.txt -out "$ciph.bin" \
        -K $K -iv $IV
    echo "Corrupting $ciph"
    cp $ciph.bin broken_$ciph.bin
    echo -n "\x00" | dd of=broken_$ciph.bin  bs=1 seek=55 count=1 conv=notrunc 
    echo "Decrypting $ciph"
    openssl enc -aes-128-$ciph -d -in broken_$ciph.bin -out broken_$ciph.txt \
        -K $K -iv $IV
done
