# Cloudflare Pages 构建设置（Zola）

本项目使用 Zola 生成静态站点。Cloudflare Pages 默认不预装 Zola，因此需要在构建步骤下载 Zola 二进制并执行构建。

## 推荐设置
- Build command：
  ```bash
  bash scripts/build-with-zola.sh
  ```
- Build output directory：
  ```
  public
  ```

保存后重新部署即可。

## 说明与可选项
- 脚本会从 GitHub Releases 下载 `zola-x86_64-unknown-linux-gnu`，适配 Pages 的 Linux 环境。
- 如需固定版本，可在脚本里改为具体版本下载地址，或在构建环境变量中设置 `ZOLA_VERSION` 并对应调整下载 URL。
- 如果你暂时不希望使用自动构建，可选择以下快速发布方式：
  - 使用 Pages 的 “Direct Upload” 将本地 `public/` 目录内容上传；
  - 或在本地执行：
    ```bash
    wrangler pages publish public --project-name <你的项目名>
    ```

## 其他注意事项
- 请确保 `config.toml` 的 `base_url` 指向你在 Pages 绑定的域名，否则站内链接可能指向错误的域。
- 本项目的输出目录为 `public/`，无需修改 Zola 默认配置。