# worknix
My work environment the way I like it, encapsulated in a vagrant vm because OSX is only fun 
for GUIs. All of it is configured with nix just because.

## vagrant
Vagrant is using a nix image and by default uses the configuration in nix/configuration.nix 
when you run `vagrant provision`. There's also some code in there that copies the ssh private 
key from the host into the vm so I don't need to add it to github and other places everytime 
a new one gets created.

### Building vagrant box
The last publicly available build of nixbos is too old, so this requires you to build your own 
or trust a random stranger who published theirs.

https://github.com/nix-community/nixbox

## home-manager
It's configured to use home-manager. The home config is in `nix/configuration.nix` and automatically 
loaded when logging in. 

## Configuring iTerm
There's a script called `vagrant_shell.sh` in the root of this folder. I've configured my iTerm 
with a custom profile called vagrant that opens up an ssh session in the new shell. 

## Inspirations
https://github.com/nocoolnametom/nix-configs
https://github.com/yrashk/nix-home
https://github.com/bobvanderlinden/nix-home/
