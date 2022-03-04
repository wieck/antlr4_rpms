Name:		antlr4
Version:	4.9.3
Release:	1BABEL
Summary:	Antlr4 C++ Runtime
License:	BSD
URL:		https://www.antlr.org/index.html

Source0:	antlr4-cpp-runtime-%{version}-source.zip
Source1:	antlr-%{version}-complete.jar

BuildRequires:	clang-devel
BuildRequires:	cmake
BuildRequires:	git
BuildRequires:	java-1.8.0-openjdk
BuildRequires:	libuuid-devel
BuildRequires:	unzip

%description
Antlr4 CPP runtime

%global debug_package %{nil}

%prep
%setup -q -c

%build
pwd
ls -l

%{__mkdir} build
cd build
cmake .. -DANTLR_JAR_LOCATION=%{SOURCE1} \
		-DCMAKE_INSTALL_PREFIX=/usr/local \
		-DWITH_DEMO=True
%{__make}


%install
%{__make} DESTDIR=%{buildroot} -C build install

#%{__mkdir} -p %{buildroot}/usr/local/lib
%{__cp} -v %{SOURCE1} %{buildroot}/usr/local/lib/


%clean
rm -rf %{buildroot}


%files
%defattr(-,root,root)
/usr/local/share/doc/libantlr4/*
/usr/local/share/antlr4-demo
/usr/local/include/antlr4-runtime/*
/usr/local/lib/libantlr4-runtime.*
/usr/local/lib/antlr-%{version}-complete.jar

%changelog

