## Creare la snap
Per poter creare l'applicazione è necessario compilare un file .snap in grado di essere installato su un ctrlX, PR21 o ctrlX virtual device.

### AMD64
setup environment:

install snapcraft

    sudo snap install snapcraft --classic

install Multipass

    sudo snap install multipass


una volta settato l'environment è possibile lanciare un terminale all' interno della cartella "code" dell' applicazione e lanciare il seguente comando:

    snapcraft 


### ARM64
Per poter buildare nativamente per ARM64 è necessario avere un rasperry pi 4 con ubuntu intallato.
setup environment:


install snapcraft

    sudo snap install snapcraft --classic

install LXD

    sudo snap install lxd

Initialize LXD

    sudo lxd init (and accept all defalutl)


una volta settato l'environment è possibile lanciare un terminale all' interno della cartella "code" dell' applicazione e lanciare il seguente comando:

    snapcraft --use-lxd

