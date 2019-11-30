set base_dir (find ~/src -maxdepth 0 -type d)

for repo in (find ~/src -mindepth 2 -maxdepth 2 -type d)
  complete -f -c g -a "(string replace '$base_dir/' '' $repo)"
end

# for repo in (find ~/src/$DOTFILES_ORG_NAME -mindepth 1 -maxdepth 1 -type d)
#   complete -f -c g -a "(basename $repo)"
# end
