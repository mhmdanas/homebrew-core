class Kubevela < Formula
  desc "Application Platform based on Kubernetes and Open Application Model"
  homepage "https://kubevela.io"
  url "https://github.com/kubevela/kubevela.git",
      tag:      "v1.6.2",
      revision: "b1cc06b0f300e254a53037514f1403ff40f2a6cd"
  license "Apache-2.0"
  head "https://github.com/kubevela/kubevela.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d20aec4b1eb5850fb1f311b7cf0fdc38f81090bc3d1142d7cdb060cb8843bea9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d20aec4b1eb5850fb1f311b7cf0fdc38f81090bc3d1142d7cdb060cb8843bea9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d20aec4b1eb5850fb1f311b7cf0fdc38f81090bc3d1142d7cdb060cb8843bea9"
    sha256 cellar: :any_skip_relocation, monterey:       "7227c74d63b185354f577e10c889d1914829212392209f4df17151770cbbf18f"
    sha256 cellar: :any_skip_relocation, big_sur:        "7227c74d63b185354f577e10c889d1914829212392209f4df17151770cbbf18f"
    sha256 cellar: :any_skip_relocation, catalina:       "7227c74d63b185354f577e10c889d1914829212392209f4df17151770cbbf18f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0ec84b01798cbbd6b0dd85403ddd72b2d8783754a72c14e779b4e38e99445d4c"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"
    ldflags = %W[
      -s -w
      -X github.com/oam-dev/kubevela/version.VelaVersion=#{version}
      -X github.com/oam-dev/kubevela/version.GitRevision=#{Utils.git_head}
    ]

    system "go", "build", *std_go_args(output: bin/"vela", ldflags: ldflags), "./references/cmd/cli"

    generate_completions_from_executable(bin/"vela", "completion", shells: [:bash, :zsh], base_name: "vela")
  end

  test do
    # Should error out as vela up need kubeconfig
    status_output = shell_output("#{bin}/vela up 2>&1", 1)
    assert_match "error: no configuration has been provided", status_output

    (testpath/"kube-config").write <<~EOS
      apiVersion: v1
      clusters:
      - cluster:
          certificate-authority-data: test
          server: http://127.0.0.1:8080
        name: test
      contexts:
      - context:
          cluster: test
          user: test
        name: test
      current-context: test
      kind: Config
      preferences: {}
      users:
      - name: test
        user:
          token: test
    EOS

    ENV["KUBECONFIG"] = testpath/"kube-config"
    version_output = shell_output("#{bin}/vela version 2>&1")
    assert_match "Version: #{version}", version_output
  end
end
