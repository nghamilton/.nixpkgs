{ stdenv, buildGoPackage, fetchFromGitHub, libvirt, pkgconfig }:

buildGoPackage rec {
  pname = "docker-machine-kvm2";
  name = "${pname}-${version}";
  version = "0.25.2";

  goPackagePath = "k8s.io/minikube";
  subPackages = [ "cmd/drivers/kvm" ];

  src = fetchFromGitHub {
    owner = "kubernetes";
    repo = "minikube";
    rev = "v${version}";
    sha256 = "1h8sxs6xxmli7xkb33kdl4nyn1sgq2b8b2d6aj5wim11ric3l7pb";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ libvirt ];

  preBuild = ''
    export buildFlagsArray=(-ldflags="-X k8s.io/minikube/pkg/drivers/kvm/version.VERSION=v${version}")
  '';

  postInstall = ''
    mv $bin/bin/kvm $bin/bin/docker-machine-driver-kvm2
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/kubernetes/minikube/blob/master/docs/drivers.md;
    description = "KVM2 driver for docker-machine.";
    license = licenses.asl20;
    maintainers = with maintainers; [ tadfisher ];
    platforms = platforms.unix;
  };
}
