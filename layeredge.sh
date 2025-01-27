#!/bin/bash

# 脚本保存路径
SCRIPT_PATH="$HOME/layeredge.sh"

# 主菜单函数
function main_menu() {
    while true; do
        clear
        echo "脚本由大赌社区哈哈哈哈编写，推特 @ferdie_jhovie，免费开源，请勿相信收费"
        echo "如有问题，可联系推特，仅此只有一个号"
        echo "================================================================"
        echo "退出脚本，请按键盘 ctrl + C 退出即可"
        echo "请选择要执行的操作:"
        echo "1. 部署 hyperspace 节点"
        echo "2. 退出脚本"
        echo "================================================================"
        read -p "请输入选择 (1/2): " choice

        case $choice in
            1)  deploy_hyperspace_node ;;
            2)  exit ;;
            *)  echo "无效选择，请重新输入！"; sleep 2 ;;
        esac
    done
}

# 部署 hyperspace 节点
function deploy_hyperspace_node() {
    # 拉取仓库
    echo "正在拉取仓库..."
    if git clone https://github.com/sdohuajia/LayerEdge.git; then
        echo "仓库拉取成功！"
    else
        echo "仓库拉取失败，请检查网络连接或仓库地址。"
        read -n 1 -s -r -p "按任意键返回主菜单..."
        main_menu
        return
    fi

    # 进入目录
    echo "进入项目目录..."
    cd LayerEdge || {
        echo "进入目录失败，请检查是否成功拉取仓库。"
        read -n 1 -s -r -p "按任意键返回主菜单..."
        main_menu
        return
    }

    # 让用户输入代理地址
    echo "请输入代理地址（格式如 http://代理账号:代理密码@127.0.0.1:8080），每次输入一个，直接按回车结束输入："
    > proxy.txt  # 清空或创建 proxy.txt 文件
    while true; do
        read -p "代理地址（回车结束）：" proxy
        if [ -z "$proxy" ]; then
            break  # 如果用户直接按回车，结束输入
        fi
        if [[ "$proxy" =~ ^http://.+@[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+:[0-9]+$ ]]; then
            echo "$proxy" >> proxy.txt  # 将代理地址写入 proxy.txt
        else
            echo "代理地址格式不正确，请重新输入！"
        fi
    done

    # 检查 wallets.txt 是否存在，如果不存在则创建并让用户输入钱包
    if [ ! -f "wallets.txt" ]; then
        echo "未找到 wallets.txt 文件，正在创建..."
        > wallets.txt  # 创建空文件

        echo "请输入钱包地址和私钥，格式为：钱包地址,私钥"
        echo "每次输入一个钱包，直接按回车结束输入："
        while true; do
            read -p "钱包地址,私钥（回车结束）：" wallet
            if [ -z "$wallet" ]; then
                break  # 如果用户直接按回车，结束输入
            fi
            if [[ "$wallet" =~ ^0x[0-9a-fA-F]{40},.+$ ]]; then
                echo "$wallet" >> wallets.txt  # 将钱包信息写入 wallets.txt
            else
                echo "钱包地址或私钥格式不正确，请重新输入！"
            fi
        done
    else
        echo "已找到 wallets.txt 文件，跳过钱包输入。"
    fi

    # 安装依赖
    echo "正在使用 npm 安装依赖..."
    if npm install; then
        echo "依赖安装成功！"
    else
        echo "依赖安装失败，请检查网络连接或 npm 配置。"
        read -n 1 -s -r -p "按任意键返回主菜单..."
        main_menu
        return
    fi

    # 提示用户操作完成
    echo "操作完成！代理已保存到 proxy.txt，钱包已保存到 wallets.txt，依赖已安装。"

    # 启动项目
    echo "正在启动项目..."
    npm start

    # 提示用户按任意键返回主菜单
    read -n 1 -s -r -p "按任意键返回主菜单..."
    main_menu
}

# 调用主菜单函数
main_menu
