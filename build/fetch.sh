#!/usr/bin/env bash
# fetches all required packages and copies them to the ROOT folder

ROOT='../cache/'

# creates the root folder if it does not exist
if [[ ! -e $ROOT ]]; then
    mkdir $ROOT
fi

# removes files from the root folder if 'clean' is passed as parameter to the shell script
if [[ $1 == "clean" ]]; then
    echo "Refreshing cache in progress...\n"
    rm $ROOT*
fi

# removes all files with zero length size which were the result of previous failed downloads
remove_empty_files() {
    find $ROOT. -size 0c -delete
}

download() {
    # if the requested file does not exist in the root folder
    if [[ ! -e $ROOT$2 ]]; then
        # if a header string is specified for the download
        if [[ $3 ]]; then
            # download using the specified HTTP header
            wget --header "$3" -O $ROOT$2 $1$2
        else
            # download without an HTTP header
            wget -O $ROOT$2 $1$2
        fi
        if [[ $? != 0 ]]; then
            remove_empty_files
            echo "ERROR: BROKEN LINK FOUND @ $1$2"
            echo "The build process cannot continue."
            echo "The likely cause of this is that the link was probably changed after the release was created."
            echo "Check that the latest master has corrected it."
            echo "If not, you need to update the fetch.sh file fixing the broken URI before trying again!"
            exit -1
        fi
    fi
}

# download from URI but assign different filename
downloadTo() {
    if [[ ! -e $ROOT$2 ]]; then
        wget -O $ROOT$2 $1
    fi
}

remove_empty_files

# download the following files to the root folder if they do not exist
download "http://download.oracle.com/otn-pub/java/jdk/8u102-b14/" "jdk-8u102-linux-x64.rpm" "Cookie: oraclelicense=accept-securebackup-cookie"
download "https://dl.google.com/linux/direct/" "google-chrome-stable_current_x86_64.rpm"
download "https://yum.dockerproject.org/repo/main/centos/7/Packages/" "docker-engine-selinux-1.12.1-1.el7.centos.noarch.rpm"
download "https://yum.dockerproject.org/repo/main/centos/7/Packages/" "docker-engine-1.12.1-1.el7.centos.x86_64.rpm"
download "https://dl.bintray.com/sbt/native-packages/sbt/0.13.12/" "sbt-0.13.12.zip"
download "https://services.gradle.org/distributions/" "gradle-3.1-bin.zip"
download "http://www.mirrorservice.org/sites/ftp.apache.org/maven/maven-3/3.3.9/binaries/" "apache-maven-3.3.9-bin.zip"
download "https://downloads.typesafe.com/typesafe-activator/1.3.10/" "typesafe-activator-1.3.10.zip"
download "http://opensource.wandisco.com/centos/7/git/x86_64/" "wandisco-git-release-7-2.noarch.rpm"
download "http://opensource.wandisco.com/centos/7/git/x86_64/" "git-2.8.0-1.WANdisco.308.x86_64.rpm"
download "http://opensource.wandisco.com/centos/7/git/x86_64/" "perl-Git-2.8.0-1.WANdisco.308.noarch.rpm"
download "http://dl.bintray.com/groovy/maven/" "apache-groovy-binary-2.4.7.zip"
download "https://releases.hashicorp.com/vagrant/1.8.6/" "vagrant_1.8.6_x86_64.rpm"
download "https://download-cf.jetbrains.com/idea/" "ideaIU-2016.2.4.tar.gz"
download "https://download-cf.jetbrains.com/idea/" "ideaIC-2016.2.4.tar.gz"
download "http://downloads.typesafe.com/scalaide-pack/4.4.1-vfinal-luna-211-20160504/" "scala-SDK-4.4.1-vfinal-2.11-linux.gtk.x86_64.tar.gz"
download "http://www.mirrorservice.org/sites/download.eclipse.org/eclipseMirror/technology/epp/downloads/release/neon/R/" "eclipse-jee-neon-R-linux-gtk-x86_64.tar.gz"
download "http://cdn.mysql.com//Downloads/MySQLGUITools/" "mysql-workbench-community-6.3.7-1.el7.x86_64.rpm"
download "https://github.com/atom/atom/releases/download/v1.8.0/" "atom.x86_64.rpm"
download "https://github.com/openshift/origin/releases/download/v1.3.0/" "openshift-origin-server-v1.3.0-3ab7af3d097b57f933eccef684a714f2368804e7-linux-64bit.tar.gz"