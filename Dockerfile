FROM openjdk:17-jdk-slim

# Install Android SDK
RUN apt-get update && apt-get install -y wget unzip && \
    wget https://dl.google.com/android/repository/commandlinetools-linux-11076708_latest.zip && \
    unzip commandlinetools-linux-11076708_latest.zip -d /opt/android-sdk && \
    rm commandlinetools-linux-11076708_latest.zip

ENV ANDROID_HOME=/opt/android-sdk
ENV PATH=$PATH:$ANDROID_HOME/cmdline-tools/latest/bin:$ANDROID_HOME/platform-tools

# Install Android SDK components
RUN yes | sdkmanager --licenses && \
    sdkmanager "platform-tools" "platforms;android-35" "build-tools;35.0.0"

WORKDIR /app
COPY . .

RUN chmod +x gradlew && ./gradlew assembleDebug

CMD ["bash"]
