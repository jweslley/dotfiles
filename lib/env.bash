# Environment variables

CDPATH=.:~:/data:/data/workspace:/usr/local

JAVA_HOME=/usr
M2_HOME=/usr/local/maven
SCALA_HOME=/usr/local/scala
SBT=/usr/local/sbt
RUBY_GEMS=/var/lib/gems/1.8
PYTHONPATH=/usr/local/lib/python:$PYTHONPATH
export JAVA_HOME PYTHONPATH

export PATH=$PATH:$JAVA_HOME/bin:$M2_HOME/bin:$SCALA_HOME/bin:$RUBY_GEMS/bin:$SBT