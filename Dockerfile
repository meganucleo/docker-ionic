FROM ubuntu:20.04

#ENV ANDROID_SDK_URL="https://dl.google.com/android/repository/commandlinetools-linux-7583922_latest.zip" \
ENV ANDROID_SDK_URL="https://dl.google.com/android/repository/commandlinetools-linux-8512546_latest.zip" \
    ANDROID_BUILD_TOOLS_VERSION=32.0.0 \
    ANT_HOME="/usr/share/java/apache-ant" \
    MAVEN_HOME="/usr/share/java/maven-3" \
    GRADLE_HOME="/usr/share/gradle" \
    SDK_MANAGER_PATH="/opt/android-sdk/cmdline-tools/latest" \
    ANDROID_SDK_ROOT="/opt/android-sdk"
ENV JAVA_VERSION 16
ENV JAVA_HOME /usr/lib/jvm/java-${JAVA_VERSION}-openjdk-amd64
ENV NVM_DIR /usr/local/nvm
ENV NODE_VERSION v16.10.0
ENV IONIC_VERSION 6.17.0
#ENV GRADLE_VERSION 7.5

ENV NODE_PATH ${NVM_DIR}/${NODE_VERSION}/lib/node_modules:${NVM_DIR}/versions/node/${NODE_VERSION}/bin
ENV PATH $PATH:$ANDROID_SDK_ROOT/cmdline-tools/bin:$ANDROID_SDK_ROOT/platform-tools:$ANDROID_SDK_ROOT/build-tools/$ANDROID_BUILD_TOOLS_VERSION:$ANT_HOME/bin:$MAVEN_HOME/bin:$NODE_PATH
#:$GRADLE_HOME/bin:$NODE_PATH

RUN rm /bin/sh && ln -s /bin/bash /bin/sh && \
    apt-get update && \
    apt-get install -yq tzdata && ln -fs /usr/share/zoneinfo/America/Mexico_City /etc/localtime && \
    dpkg-reconfigure -f noninteractive tzdata && \
    apt-get -y install openjdk-${JAVA_VERSION}-jdk-headless python git unzip bzip2 openssh-client && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
    java -version && \
    apt-get update && apt-get install -y curl gnupg2 lsb-release && \
    #curl -fsSL https://deb.nodesource.com/gpgkey/nodesource.gpg.key | apt-key add - && \
    #apt-key fingerprint 1655A0AB68576280 && \
    #export VERSION=node_16.x && \
    #export DISTRO="$(lsb_release -s -c)" && \
    #echo "deb https://deb.nodesource.com/$VERSION $DISTRO main" | tee /etc/apt/sources.list.d/nodesource.list && \
    #echo "deb-src https://deb.nodesource.com/$VERSION $DISTRO main" | tee -a /etc/apt/sources.list.d/nodesource.list && \
    #apt-get update && apt-get install -y nodejs && \
    mkdir -p ${NVM_DIR} && \
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.37.2/install.sh | /bin/bash && \
    . $NVM_DIR/nvm.sh && nvm install ${NODE_VERSION} && nvm alias default ${NODE_VERSION} && \
    node -v && npm -v && \
    whereis npm && \
    npm install -g --unsafe-perm @ionic/cli@${IONIC_VERSION} && \
    ionic --version && \
    cd /tmp && \
    ionic start myNewProject blank --type=react --capacitor && \
    cd myNewProject && \
    ionic capacitor build android --no-open && \
    rm -rf /tmp/myNewProject && \
    rm -rf /var/lib/apt/lists/* && apt-get clean && \
    apt-get -qq update && \
    apt-get -qq install -y wget curl maven ant && \
    #wget https://services.gradle.org/distributions/gradle-${GRADLE_VERSION}-bin.zip -P /tmp && \
    #unzip -d /opt/gradle /tmp/gradle-${GRADLE_VERSION}-bin.zip && \
    #ln -s /opt/gradle/gradle-${GRADLE_VERSION} ${GRADLE_HOME} && \
    mkdir ${ANDROID_SDK_ROOT} && cd ${ANDROID_SDK_ROOT} && \
    wget -O tools.zip ${ANDROID_SDK_URL} && \
    unzip tools.zip && rm tools.zip && \
    mkdir /root/.android && touch /root/.android/repositories.cfg && \
    while true; do echo 'y'; sleep 2; done | sdkmanager --sdk_root=${ANDROID_SDK_ROOT} "platform-tools" "build-tools;${ANDROID_BUILD_TOOLS_VERSION}" && \
    while true; do echo 'y'; sleep 2; done | sdkmanager --sdk_root=${ANDROID_SDK_ROOT} "platforms;android-25" "platforms;android-26" "platforms;android-27" && \
    while true; do echo 'y'; sleep 2; done | sdkmanager --sdk_root=${ANDROID_SDK_ROOT} "platforms;android-28" "platforms;android-29" "platforms;android-30" && \
    while true; do echo 'y'; sleep 2; done | sdkmanager --sdk_root=${ANDROID_SDK_ROOT} "platforms;android-31" "platforms;android-32" && \
    while true; do echo 'y'; sleep 2; done | sdkmanager --sdk_root=${ANDROID_SDK_ROOT} "extras;android;m2repository" "extras;google;google_play_services" "extras;google;instantapps" "extras;google;m2repository" &&  \
    while true; do echo 'y'; sleep 2; done | sdkmanager --sdk_root=${ANDROID_SDK_ROOT} "add-ons;addon-google_apis-google-22" "add-ons;addon-google_apis-google-23" "add-ons;addon-google_apis-google-24" "skiaparser;1" && \
    while true; do echo 'y'; sleep 2; done | sdkmanager --sdk_root=${ANDROID_SDK_ROOT} --licenses && \
    mkdir -p $ANDROID_SDK_ROOT && \
    chmod a+x -R $ANDROID_SDK_ROOT && \
    chown -R root:root $ANDROID_SDK_ROOT && \
    #rm -rf ${ANDROID_SDK_ROOT}/licenses && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
    apt-get autoremove -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
    mvn -v  && java -version && ant -version
    # gradle -version
