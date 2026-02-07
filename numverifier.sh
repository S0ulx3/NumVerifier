#!/bin/bash

# Función Ctrl+C

function ctrl_c (){
tput civis
clear
echo -e "\e[31m\n\n|------------------|"
          echo -e "| [!] Saliendo...  |"
          echo -e "|------------------|\n\n\e[0m"

sleep 0.7
tput cnorm; exit 1
}

# Ctrl+C

trap ctrl_c INT

# APIKEY

API_KEY="$(cat .api.txt 2>/dev/null)"


# Verificación de dependencias

for requirements in jq curl; do

if $(! which $requirements)
then

clear
echo -e "\n\e[31m[ Comando \e[34m$requirements\e[31m no instalado, instalando... ]\e[0m\n"

sudo apt install "$requirements" -y

else
:
fi

clear

done



# Menú
tput civis
	echo -e "\n\t\e[44m\e[30m [ Bienvenido a NumVerifier By \e[46m\e[30mS0ulx3\e[44m\e[30m ]\e[0m\n"

	if [ -e ./.api.txt ]; then
	:
	else
	echo -e "\n\t\e[31m [!] Esto solo ocurrirá una vez.\e[34m"
	echo -e "\t\e[34m [?] Inserta tu API Key de https://numverify.com\e[31m"
	read -p "	  ---> " apikey
	echo "$apikey" > .api.txt
	echo
	fi
	echo -e "\t\e[34m [?] Inserta el numero que desees verificar.\e[0m"
	echo -e "\t\e[34m [?] Por ejemplo: \e[36m+34123456789 \n\e[31m"
	read -p "	  ---> " PHONE_NUMBER
	sleep 1
tput cnorm

# Funcion para verificar el número

RESPONSE=$(curl -s "http://apilayer.net/api/validate?access_key=$API_KEY&number=$PHONE_NUMBER")

# Usa 'jq' para formatear la respuesta
tput civis
echo; echo -e $RESPONSE | jq -r '[
    "Número de teléfono: \(.number)",
    "Formato local: \(.local_format)",
    "Formato internacional: \(.international_format)",
    "Prefijo del país: \(.country_prefix)",
    "Código del país: \(.country_code)",
    "Nombre del país: \(.country_name)",
    "Ubicación: \(.location)",
    "Operador: \(.carrier)",
    "Tipo de línea: \(.line_type)"
] | .[]'

sleep 1
tput cnorm; exit 1
