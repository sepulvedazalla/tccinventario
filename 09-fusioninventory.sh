#!/bin/bash
# Autor: Rafael Sepulveda Zalla
# Data de criação: 14/01/2020
# Data de atualização: 14/01/2020
# Versão: 0.3
# Testado e homologado para a versão do Ubuntu Server 16.04 LTS x64
# Kernel >= 4.4.x
#
# Instalação do Fusion Inventory Server e Agent com integração com GLPI
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
					 #Exportando a variável do Debian Frontend Noninteractive para não solicitar interação com o usuário
					 export DEBIAN_FRONTEND=noninteractive
					 echo
					 echo  ============================================================ &>> $LOG
					 
					 echo -e "Instalação do sistema de Inventário de Rede FusionInventory"
					 echo -e "Pressione <Enter> para instalar"
					 read
					 sleep 2
					 echo
					 
					 echo -e "Fazendo o download do FusionInventory Server e Agent integrado com o GLPI"
					 
					 #Download do FusionInventory Server, Pluguin do GLPI Help Desk
					 wget https://github.com/fusioninventory/fusioninventory-for-glpi/releases/download/$GLPIFISVERSION &>> $LOG
					 
					 #Download do FusionInventory Agent, integração com GLPI ou OCS Inventory
					 wget https://github.com/fusioninventory/fusioninventory-agent/releases/download/$GLPIFIAVERSION &>> $LOG
					 
					 echo -e "Download Feito com sucesso!!!, continuando o script"
					 echo
					 
					 echo -e "Descompactando o Fusion Inventory Server e Agent"
					 
					 #Descompactando o Fusion Inventory Server
					 tar -jxvf $GLPIFISTAR &>> $LOG
					 
					 #Descompactando o Fusion Inventory Agent
					 tar -zxvf $GLPIFIATAR &>> $LOG
					 
					 echo -e "Arquivos descompactados com sucesso!!!, continuando o script"
					 echo
					 
					 echo -e "Movendo o diretório do FusionInventory Server para o GLPI"
					 
					 #Movendo o diretório do FusionInventory Server para o Diretório de Pluguin do GLPI
					 mv -v $GLPIFISINSTALL /var/www/html/glpi/plugins/ &>> $LOG
					 
					 echo -e "Diretório movido com sucesso!!!, continuando o script"
					 echo
					 
					 echo -e "Instalando o FusionInventory Agent, pressione <Enter> para continuar."
					 read
					 sleep 2
					 clear
					 
					 #Acessando o diretório do FusionInvetory Agent
					 cd $GLPIFIAINSTALL
					 
					 echo -e "Configurando o FusionInventory Agent"
					 echo
					 
					 #Configurando as opções do Fusion Inventory Agent e checando as dependências"
					 perl -I. Makefile.PL &>> $LOG
					 echo
					 echo -e "Fusion Inventory configurado com sucesso!!!, pressione <Enter> para continuar"
					 read
					 sleep 3
					 clear
					 
					 #Compilando o FusionInventory Agent
					 make &>> $LOG
					 echo
					 echo -e "FusionInventory compilado com sucesso!!!, pressione <Enter> para continuar"
					 read
					 sleep 3
					 clear
					 
					 #Instalando o Fusion Inventory Agent
					 make install &>> $LOG
					 echo
					 echo -e "FusionInventory Agent instalado com sucesso!!!, pressione <Enter> para continuar."
					 read
					 sleep 2
					 clear
					 
					 echo -e "Copiando o arquivo de configuração do FusionInventory"
					 
					 cp -v /usr/local/etc/fusioninventory/agent.cfg /usr/local/etc/fusioninventory/agent.cfg.old &>> $LOG
					 echo -e "Backup feito com sucesso!!!, continuando o script"
					 sleep  2
					 
					 cp conf/agent.cfg /usr/local/etc/fusioninventory/agent.cfg &>> $LOG
					 echo -e "Arquivo atualizado com sucesso!!!, continuando o script"
					 sleep  2
					 
					 echo -e "Pressione <Enter> para editar o arquivo"
					 read
					 vim /usr/local/etc/fusioninventory/agent.cfg
					 echo -e "Arquivo editado com sucesso!!!, continuando com o script"
					 sleep 2
					 
					 echo -e "Executando o inventário pela primeira vez"
					 fusioninventory-agent --debug &>> $LOG
					 echo -e "Inventário feito com sucesso!!!!, continuando o script"
					 sleep 2
					 
           				 echo  ============================================================ >> $LOG
                     
					 echo -e "Fim do $LOGSCRIPT em: `date`" &>> $LOG
					 echo -e "Instalação do FusionInventory Server e Agent feito com Sucesso!!!!!"
					 echo
					 # Script para calcular o tempo gasto para a execução do fusioninventory.sh
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
