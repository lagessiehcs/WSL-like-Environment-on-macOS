# WSL-like-Environment-on-macOS
A guide to creating a lightweight Linux development environment on macOS as an alternative to WSL.

## Prerequisites
The following need to be installed on the mac:
1. [OrbStack](https://orbstack.dev/)
2. [iTerm2](https://iterm2.com/)
3. [XQuartz](https://www.xquartz.org/)

## Setting Up
### SSH
Follow [Github's Instruction](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent#generating-a-new-ssh-key) to create an ssh key pair on the Mac. This should be done before any machine is created.
### OrbStack 
1. Create a new Ubuntu machine in OrbStack
2. If the new machine is created before an ssh keypair, or the key pair (e.g. ```id_ed25519``` and ```id_ed25519.pub```) is not found under ```~/.ssh``` of the machine, it should be manually copy from the Mac (under ```~/.ssh```) to the new machine (under ```~/.ssh```).
3. Copy the file ```setup_ssh.sh``` into the new machine. This file contains the commands for setting up the new machine to enable GUI.
4. Open new terminal in the VM by double-clicking on the machine in Orbstack
5. Make the file executable
   ```
   chmod +x ./setup_ssh.sh
   ```
6. Run the file
   
### iTerm2
1. Open iTerm2's settings &rarr; **Profiles**, click "*" to add new profile.
2. Click on the newly added profile, then go to the ```General``` tab and fill the fields as follows:
   - ```Name```: Name of the profile.
   - ```Command```:
     - Dropdown: Command
     - Copy the following to the ```Command```field and replace ```<machine-name>``` with the name of the new machine created in step 1 of [OrbStack](#OrbStack)
       ```
       zsh -c '[[ "$(/usr/local/bin/orb status 2>/dev/null)" == *"Stopped"* ]] && /usr/local/bin/orb start; ssh -Y <machine-name>.orb.local'

       ```
3. (Optional) Go to the ```Color```tab and change the default background color to ```2c001e```to recreate the color of an Ubuntu terminal.

### Start New Ubuntu Session
To start a new Ubuntu session, simple right click on the iTerm2's terminal, then _New tab_ and choose the configured profile.

##Source
[GUI in OrbStack machines](https://www.nickgregorich.com/posts/gui-in-orbstack-machines/)
