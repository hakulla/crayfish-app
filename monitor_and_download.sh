#!/bin/bash

TOKEN="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"
REPO="hakulla/crayfish-app"
MAX_WAIT=600  # 最多等待10分钟
SLEEP_INTERVAL=10  # 每10秒检查一次

echo "🔍 监控GitHub Actions构建状态..."
echo "📦 仓库: $REPO"
echo "⏱️  最多等待: ${MAX_WAIT}秒"
echo ""

elapsed=0
while [ $elapsed -lt $MAX_WAIT ]; do
    # 获取最新的工作流运行
    response=$(curl -s -H "Authorization: token $TOKEN" \
        "https://api.github.com/repos/$REPO/actions/runs?per_page=1")

    # 提取状态和结论
    status=$(echo "$response" | grep -o '"status":"[^"]*"' | head -1 | cut -d'"' -f4)
    conclusion=$(echo "$response" | grep -o '"conclusion":"[^"]*"' | head -1 | cut -d'"' -f4)

    echo "⏳ [$elapsed秒] 状态: $status, 结论: $conclusion"

    # 检查是否完成
    if [ "$status" == "completed" ]; then
        echo ""
        echo "✅ 构建完成！结论: $conclusion"

        if [ "$conclusion" == "success" ]; then
            echo ""
            echo "📥 开始下载APK..."

            # 获取工作流ID
            run_id=$(echo "$response" | grep -o '"id":[0-9]*' | head -1 | cut -d':' -f2)

            # 获取artifacts
            artifacts=$(curl -s -H "Authorization: token $TOKEN" \
                "https://api.github.com/repos/$REPO/actions/runs/$run_id/artifacts")

            # 下载debug APK
            debug_url=$(echo "$artifacts" | grep -A 20 '"name":"crayfish-apk"' | grep -o '"archive_download_url":"[^"]*"' | cut -d'"' -f4)
            release_url=$(echo "$artifacts" | grep -A 20 '"name":"crayfish-apk-release"' | grep -o '"archive_download_url":"[^"]*"' | cut -d'"' -f4)

            echo ""
            if [ -n "$debug_url" ]; then
                echo "📦 下载Debug APK..."
                curl -L -H "Authorization: token $TOKEN" "$debug_url" -o /Users/adrianchen/Desktop/crayfish-debug.zip
                echo "✅ Debug APK已下载到: /Users/adrianchen/Desktop/crayfish-debug.zip"

                # 解压
                cd /Users/adrianchen/Desktop
                unzip -o crayfish-debug.zip
                echo "✅ APK已解压到: /Users/adrianchen/Desktop/app-debug.apk"

                # 移动到桌面
                mv app-debug.apk /Users/adrianchen/Desktop/app-debug.apk 2>/dev/null || true
            fi

            if [ -n "$release_url" ]; then
                echo "📦 下载Release APK..."
                curl -L -H "Authorization: token $TOKEN" "$release_url" -o /Users/adrianchen/Desktop/crayfish-release.zip
                echo "✅ Release APK已下载到: /Users/adrianchen/Desktop/crayfish-release.zip"

                # 解压
                cd /Users/adrianchen/Desktop
                unzip -o crayfish-release.zip
                echo "✅ APK已解压到: /Users/adrianchen/Desktop/app-release.apk"

                # 移动到桌面
                mv app-release.apk /Users/adrianchen/Desktop/app-release.apk 2>/dev/null || true
            fi

            echo ""
            echo "🎉 完成！APK已保存到桌面"
            echo "📱 安装命令: adb install /Users/adrianchen/Desktop/app-debug.apk"
            exit 0
        else
            echo "❌ 构建失败！请查看: https://github.com/$REPO/actions"
            exit 1
        fi
    fi

    # 等待
    sleep $SLEEP_INTERVAL
    elapsed=$((elapsed + SLEEP_INTERVAL))
done

echo ""
echo "⏰ 超时！构建可能仍在进行中"
echo "🔗 查看构建进度: https://github.com/$REPO/actions"
exit 1
