{ ... }:

{
  programs.git = {
    enable = true;
    userName = "Jonas Holst Damtoft";
    userEmail = "jonasdamtoft@hotmail.com";
    signing.signByDefault = true;
    signing.key = "F135EB6E5796123F11166E40B41F19B1BAD55D37";
    extraConfig = {
      users.email = "Jomik@users.noreply.github.com";
    };
    aliases = {
      unstage = "reset HEAD --";
      discard = "checkout --";
      last = "log -3 HEAD";
      oops = "commit --amend --no-edit";
      ignored = "ls-files --others --i --exclude-standard";
      l = "log --graph --pretty='%Cred%h%Creset - %C(bold blue)<%an>%Creset %s%C(yellow)%d%Creset %Cgreen(%cr)' --abbrev-commit --date=relative";
    };
  };
}
