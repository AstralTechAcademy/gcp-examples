sudo apt update
sudo apt install git cmake curl g++ zip unzip tar

cd
git clone https://github.com/microsoft/vcpkg.git
cd vcpkg && ./bootstrap-vcpkg.sh
export VCPKG_ROOT=~/vcpkg
export PATH=$VCPKG_ROOT:$PATH

mkdir -p $HOME/Downloads/pkgconf && cd $HOME/Downloads/pkgconf
sudo rm -f /usr/bin/pkgconf /usr/bin/pkg-config
curl -fsSL https://distfiles.ariadne.space/pkgconf/pkgconf-2.2.0.tar.gz | \
    tar -xzf - --strip-components=1 && \
    ./configure --prefix=/usr -with-pkg-config-dir=/usr/local/lib/x86_64-linux-gnu/pkgconfig:/usr/local/lib/pkgconfig:/usr/local/share/pkgconfig:/usr/lib/x86_64-linux-gnu/pkgconfig:/usr/lib/pkgconfig:/usr/share/pkgconfig && \
    make -j ${NCPU:-4} && \
sudo make install && \
sudo ldconfig && cd /var/tmp && rm -fr build
sudo ln -s /usr/bin/pkgconf /usr/bin/pkg-config

mkdir -p $HOME/Downloads/crc32c && cd $HOME/Downloads/crc32c
curl -fsSL https://github.com/google/crc32c/archive/1.1.2.tar.gz | \
    tar -xzf - --strip-components=1 && \
    cmake \
        -DCMAKE_BUILD_TYPE=Release \
        -DBUILD_SHARED_LIBS=yes \
        -DCRC32C_BUILD_TESTS=OFF \
        -DCRC32C_BUILD_BENCHMARKS=OFF \
        -DCRC32C_USE_GLOG=OFF \
        -S . -B cmake-out && \
    cmake --build cmake-out -- -j ${NCPU:-4} && \
sudo cmake --build cmake-out --target install -- -j ${NCPU:-4} && \
sudo ldconfig

cd
git clone https://github.com/googleapis/google-cloud-cpp.git --depth=1

cd ~/google-cloud-cpp
cmake -S . -B cmake-out -DBUILD_TESTING=OFF -DGOOGLE_CLOUD_CPP_ENABLE_EXAMPLES=OFF -DCMAKE_TOOLCHAIN_FILE=$HOME/vcpkg/scripts/buildsystems/vcpkg.cmake -DGOOGLE_CLOUD_CPP_ENABLE=storage 
cmake --build cmake-out --target install

