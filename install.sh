ninja -t clean
python configure.py $1
ninja
mkdir -p ${prefix}
rm -rf ${prefix}/lib ${prefix}/include
mkdir -p ${prefix}/lib
cp -f lib/$1/*.a ${prefix}/lib/
cp -rf include/ ${prefix}
