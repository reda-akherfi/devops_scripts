

* sudo  dnf update -y
* sudo dnf install vim git tmux tree

* git config --global init.defaultBranch main
  git config --global user.name reda
                      user.email redaakherfi07@gmail.com
                      core.editor vim
                      http.postBuffer 5242880

* ssh-keygen -t rsa -b 4096 -C "ssh key for accessing github repos from the defiant"
  eval "$(ssh-agent -s)"
  ssh-add ~/.ssh/id_rsa
  
  Host github.com
    HostName github.com
    User git
    IdentityFile ~/.ssh/...
    IdentitiesOnly yes

  test it with `ssh -T git@github.com`
  git clone git@github.com:reda-akherfi/dottas.git
  git clone git@github.com:reda-akherfi/devops_scripts.git
________________________________________________________________________________________
