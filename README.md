# EKS k6 Operator Example

## 概要
このリポジトリは、Terraformを使用してAmazon EKSクラスタを構築し、k6 Operatorを利用してKubernetes上で分散負荷テストを実行するための一例です。ディレクトリは主に`terraform`と`k6-operator`に分かれており、それぞれインフラストラクチャの構築とテストの実行に関する設定が含まれています。

## ディレクトリ構成
```
eks-k6-operator-example/
│
├── terraform/                 # Terraformを使用したEKSクラスタの構築
│   ├── README.md              # Terraform設定の説明
│   ├── main.tf                # メインのTerraform設定ファイル
│   ├── providers.tf           # AWSプロバイダーの設定
│   ├── terraform.tfstate      # Terraformの状態ファイル（実際のプロジェクトでは.gitignore推奨）
│   └── terraform.tfstate.backup # Terraformの状態ファイルのバックアップ
│
└── k6-operator/               # k6 Operatorを使用したKubernetes上での負荷テスト
    ├── README.md              # k6 Operatorに関する説明
    ├── manifests/             # k6 Operatorのカスタムリソース定義などのKubernetesマニフェスト
    │   └── run-k6-from-configmap.yaml # k6テスト実行用のConfigMap
    └── scripts/               # k6テストスクリプト
        └── test.js            # k6のテストスクリプト
```

## 使用方法

### 1. Terraformを使用したEKSクラスタの構築

まず、`terraform/`ディレクトリに移動し、TerraformでEKSクラスタを構築します。`main.tf`や`providers.tf`などの設定ファイルを適切に編集し、`terraform apply`を実行します。

```sh
cd terraform/
terraform init
terraform apply
```

### 2. k6 Operatorを使用した負荷テスト

EKSクラスタが構築されたら、`k6-operator/`ディレクトリに移動し、k6 Operatorを使用してKubernetes上で負荷テストを実行します。

```sh
cd ../k6-operator/
kubectl apply -f manifests/run-k6-from-configmap.yaml
```

テスト実行後、Podのログを確認してテスト結果を取得できます。

```sh
kubectl logs <pod-name>
```

## クリーンアップ

すべてのリソースを削除するには、`kubectl`でk6リソースを削除し、その後、`terraform`を使用してインフラストラクチャを削除します。

```sh
cd k6-operator/
kubectl delete -f manifests/run-k6-from-configmap.yaml

cd ../terraform/
terraform destroy
```

## 必要なツール

- Terraform 1.0.0以上
- AWS CLIと適切に設定されたプロファイル
- Kubernetesクラスタと`kubectl`
- k6 OperatorがインストールされたKubernetesクラスタ

## 参考資料

- [Terraform Documentation](https://www.terraform.io/docs)
- [k6 Operator GitHub Repository](https://github.com/grafana/k6-operator)
- [Kubernetes Documentation](https://kubernetes.io/docs/)
