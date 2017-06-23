#! /bin/sh -

# handle the gitolite.rc
if [  -f "/home/git/repositories/gitolite.rc" ]; then
  echo 'import rc file'
  su git -c "cp /home/git/repositories/gitolite.rc /home/git/.gitolite.rc"
else
  echo 'export rc file'
  su git -c "cp /home/git/.gitolite.rc /home/git/repositories/gitolite.rc"
fi

if [ -f /home/git/.gitolite-configured ]; then
  su git -c "/home/git/bin/gitolite setup"
else
  # handle the ssh key
  echo 'Using SSH-key'
  cat /home/git/.ssh/id_rsa.pub
  su git -c "/home/git/bin/gitolite setup -pk=/home/git/.ssh/id_rsa.pub"
  su git -c "touch /home/git/.gitolite-configured"
fi

/usr/sbin/sshd -D
