#!/bin/bash
# Autor: Rafael Sepulveda Zalla
# Data de criação: 14/01/2020
# Data de atualização: 14/01/2020
# Versão: 0.1
# Testado e homologado para a versão do Ubuntu Server 16.04.x LTS x64
# Kernel >= 4.4.x
#
# Download dos Plugins do OCS Inventory
#
# Utilizar o comando: sudo -i para executar o script
#

# Arquivo de configuração de parâmetros
source 00-parametros.sh
#

# Caminho para o Log do script
LOG=$VARLOGPATH/$LOGSCRIPT
#

if [ "$USUARIO" == "0" ]
then
	if [ "$UBUNTU" == "16.04" ]
		then
			if [ "$KERNEL" == "4.4" ]
				then
					 clear
					 
					 echo -e "Usuário é `whoami`, continuando a executar o $LOGSCRIPT"
					 echo
					 echo  ============================================================ &>> $LOG
					 
					 echo -e "Download dos Plugins do OCS Inventory"
					 echo -e "Pressione <Enter> para começar o Download"
					 read
					 sleep 2
					 echo
					 
					 echo -e "Download dos arquivos, aguarde..."
					 wget $DRIVERLIST -O /usr/share/ocsinventory-reports/ocsreports/extensions/drivelist.zip &>> $LOG
					 wget $UPTIME -O /usr/share/ocsinventory-reports/ocsreports/extensions/uptime.zip &>> $LOG
					 echo -e "Download dos arquivos concluído com sucesso!!!, continuando o script"
					 echo
					 
					 echo -e "Descompactando todos os arquivos Zipados, aguarde..."
					 cd /usr/share/ocsinventory-reports/ocsreports/extensions/
					 	for i in $(ls *.zip);do unzip $i; done &>> $LOG
					 cd - &>> $LOG
					 echo -e "Arquivos descompactados com sucesso!!!, continuando o script"
					 echo
					 sleep 2
					 
					 echo -e "Listando o contéudo do diretório"
					 echo
					 ls -lh /usr/share/ocsinventory-reports/ocsreports/extensions/
					 echo
					 echo -e "Arquivos listados com sucesso!!!, pressione <Enter> para continuar"
					 read
					 sleep 2
					 clear
				 
           				 echo  ============================================================ >> $LOG
                     
					 echo -e "Fim do $LOGSCRIPT em: `date`" &>> $LOG
					 echo -e "Finalização do Download dos Plugins feito com Sucesso!!!!!"
					 echo
					 # Script para calcular o tempo gasto para a execução do agents.sh
						 DATAFINAL=`date +%s`
						 SOMA=`expr $DATAFINAL - $DATAINICIAL`
						 RESULTADO=`expr 10800 + $SOMA`
						 TEMPO=`date -d @$RESULTADO +%H:%M:%S`
					 echo -e "Tempo gasto para execução do netdata.sh: $TEMPO"
					 echo -e "Pressione <Enter> para reinicializar o servidor: `hostname`"
					 read
					 sleep 2
					 reboot
					 else
						 echo -e "Versão do Kernel: $KERNEL não homologada para esse script, versão: >= 4.4 "
						 echo -e "Pressione <Enter> para finalizar o script"
						 read
			fi
	 	 else
			 echo -e "Distribuição GNU/Linux: `lsb_release -is` não homologada para esse script, versão: $UBUNTU"
			 echo -e "Pressione <Enter> para finalizar o script"
			 read
	fi
else
	 echo -e "Usuário não é ROOT, execute o comando com a opção: sudo -i <Enter> depois digite a senha do usuário `whoami`"
	 echo -e "Pressione <Enter> para finalizar o script"
	read
fi
