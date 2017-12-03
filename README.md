# AutoPoleTelegramBot
Bot que corre en una cuenta de usuario y envía un mensaje todos los días a las 00:00 a los chats y texto que quieras.


## Requisitos previos

Necesitas un servidor Linux para poder correr este script, preferiblemente con **Ubuntu 16**. En otros Linux no lo he probado.

## Instalación

Necesitas instalar varias dependencias antes de poder lanzar el bot (Lua, Redis, dependencias de Tdlib...), algunas algo delicadas de instalar en ciertos casos. Si lo instalas tal cual digo en Ubuntu 16 debería ir bien a la primera:

```bash
sudo apt-get update && sudo apt-get upgrade -y && sudo apt-get install git redis-server lua5.2 liblua5.2-dev lua-lgi libnotify-dev unzip tmux -y && add-apt-repository ppa:ubuntu-toolchain-r/test && sudo apt-get update && apt-get upgrade && sudo apt-get install libconfig++9v5 libstdc++6 && sudo apt autoremove
```                   
                      

En el caso de que salegan errores como `version GLIBCXX_3.4.21 not defined`, descarga manualmente libstdc++6 desde [aquí](https://packages.ubuntu.com/xenial/libstdc++6), instala el paquete con `dpkg -i` y repite el paso anterior a este.


Si no te ha dado ningun problema (esperemos que no), puedes empezar con el bot.
Antes hay que bajar el binario de la nueva versión de Tdcli, que usa el nuevo Tdlib y ahora se llama "Telegram-Bot"
Ese binario se descarga de aquí: https://valtman.name/telegram-bot
Usa la última versión estable.


Ese binario lo tienes que poner en tu servidor linux, haces una carpeta ```mkdir bot ``` y lo metes.

Cambia el nombre para que sea más manejable ```mv  telegram-bot-* tg ```

Dale permisos de ejecución ```chmod +x tg ```

Ya puedes lanzar el bot, pero antes hay que loguearse con tu número de teléfono ```./tg -p main --login --phone=34288288```

__El número tiene que ir con prefijo y sin el +__


Presiona enter y te pedirá el código de confirmación. En tu Telegram te llegará y lo introduces a la línea de comandos escribiéndolo y le das a enter. No se verán los números que pones pero si se están metiendo.

Bájate el **pole.lua** de este repositorio y mételo en la misma carpeta que el binario de Tdcli


Ya puedes iniciar el bot con ```./tg -p main -v 0 -s $(pwd)/pole.lua | grep -v "{"```



## Notas

- Los chats y los textos que quieras enviar se configuran dentro del pole.lua, en la zona donde hay comentarios. Puedes poner tantos chats y mensajes como quieras.

- Asegúrate de tener la hora del servidor en la zona horaria correcta.

- Tdcli tiene varias limitaciones para usar sus funciones y necesita recibir una update para poder hacer cosas. Si ves que el código del bot es algo extraño es por esta razón. Además de esto, el bot necesita "descubir" los canales antes de interactuar con ellos. Si en el log del bot sale "chat not found" es o por que lo has escrito mal o no ha recibido updates de ese chat todavía.

- Para mantener el bot corriendo en segundo plano recomiendo usar Tmux.

