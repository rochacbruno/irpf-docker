# IRPF: Declaração de Imposto no Docker
Instalar o Java? Não, obrigado.

Inspirado e forkado do @aureliojargas/carne-leao-docker

Este repo roda o programa da receita para envio da declaração do IRPF 2020.

> Esta imagem assume que caso você já tenha a pasta `ProgramasRFB` ela estará disponível no container para que você possa importar a declaração de anos anteriores.


## Rodar de imagem pronta no DockerHub

```bash
mkdir ~/ProgramasRFB  # ignore caso já tenha a pasta de anos anteriores

xhost +local:docker

docker run --rm \
    -e DISPLAY \
    -e _JAVA_OPTIONS='-Dawt.useSystemAAFontSettings=on' \
    -v /tmp/.X11-unix:/tmp/.X11-unix \
    -v ~/ProgramasRFB:/home/irpf/ProgramasRFB \
    rochacbruno/irpf

xhost -local:docker
```

## buildar e rodar, localmente

```bash
git clone https://github.com/rochacbruno/irpf-docker.git
cd irpf-docker

mkdir ~/ProgramasRFB  # ignore caso vc ja tenha a pasta de anos anteriores

docker-compose build

xhost +local:docker && docker-compose up
xhost -local:docker
```

## Detalhes

- Estou assumindo que você roda o docker e docker-compose sem precisar de `sudo`. Caso contrário, coloque os `sudo` apropriados.

- Você tem que criar o diretório `~/ProgramasRFB` antes de rodar o contêiner, senão esse diretório será criado pelo usuário `root` e você terá que arrumar as permissões manualmente. (ignore caso você já tenha esse diretório de anos anteriores)

- Você sabe que os certificados desses sites do governo é uma novela, né? Por isso precisa da opção `--no-check-certificate` ao baixar o programa (vide `Dockerfile`) :(

- [Por que precisa do xhost?](http://wiki.ros.org/docker/Tutorials/GUI)

## Contribuições

Sua ajuda é muito bem-vinda! Se virar o ano e eu não atualizar a imagem, ou se você tem uma sugestão de melhoria, mande seu Pull Request.

## Créditos

Imagem do carne leão do aurelio/
https://github.com/aureliojargas/carne-leao-docker

Inspirado pelo [andresmrm/docker-irpf](https://github.com/andresmrm/docker-irpf), que disponibilizou o programa principal do IRPF numa imagem com o Alpine Linux.

A diferença desta aqui é que ela mantem o acesso a pasta ProgramasRFB
