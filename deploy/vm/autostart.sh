#!/bin/bash
echo "   _____            _               _   _ _   _ ";
echo "  / ____|          | |             | \ | | \ | |";
echo " | |     ___  _ __ | |__   _____  _|  \| |  \| |";
echo " | |    / _ \| '_ \| '_ \ / _ \ \/ / . \` | . \` |";
echo " | |___| (_) | | | | |_) |  __/>  <| |\  | |\  |";
echo "  \_____\___/|_| |_|_.__/ \___/_/\_\_| \_|_| \_|";
echo "                                                ";
echo "                                                ";

pause(){
 read -n1 -rsp $'Press any key to close the terminal...\n'
}

echo Version 2018-08-30
echo https://github.com/a00908270/
echo "                                                ";

echo Starting Kubernetes ...
sleep 20;
echo Starting ConbexNN Services ...
sleep 30;
echo Waiting for Service vinnsl-service ... This can take a few minutes
bash -c 'while [[ "$(curl -I -s -o /dev/null -w ''%{http_code}'' https://cluster.local/vinnsl/ --insecure)" != "200" ]]; do sleep 5; done'
echo vinnsl-service UP

echo Waiting for UI service ...
bash -c 'while [[ "$(curl -I -s -o /dev/null -w ''%{http_code}'' https://cluster.local/#/ --insecure)" != "200" ]]; do sleep 5; done'
echo vinnsl-nn-ui UP

echo Importing Iris Dataset ...
curl --insecure --request POST \
  --url 'https://cluster.local/storage/upload' \
  --form 'file=@/home/conbexnn/Downloads/iris.txt'
echo "                                                ";
echo Done

echo Importing Iris Classification ViNNSL Network ...

curl --insecure --request POST \
  --url 'https://cluster.local/vinnsl/' \
  --header 'Cache-Control: no-cache' \
  --header 'Content-Type: application/xml' \
  --header 'Postman-Token: d74ef5cf-ac66-462f-8b11-529cc7ff7d28' \
  --data '<vinnsl>\n  <description>\n    <identifier><!-- will be generated --></identifier>\n    <metadata>\n      <paradigm>classification</paradigm>\n      <name>Backpropagation Classification</name>\n      <description>Iris Classification Example</description>\n      <version>\n        <major>1</major>\n        <minor>0</minor>\n      </version>\n    </metadata>\n    <creator>\n      <name>Ronald Fisher</name>\n      <contact>ronald.fisher@institution.com</contact>\n    </creator>\n    <problemDomain>\n      <propagationType type="feedforward">\n        <learningType>supervised</learningType>\n      </propagationType>\n      <applicationField>Classification</applicationField>\n      <networkType>Backpropagation</networkType>\n      <problemType>Classifiers</problemType>\n    </problemDomain>\n    <endpoints>\n      <train>true</train>\n      <retrain>true</retrain>\n      <evaluate>true</evaluate>\n    </endpoints>\n    <structure>\n	   <input>\n	    <ID>Input1</ID>\n	    <size>\n	    	<min>4</min>\n	    	<max>4</max>\n	    </size>\n	   </input>\n	   <hidden>\n	    <ID>Hidden1</ID>\n	    <size>\n	    	<min>3</min>\n	    	<max>3</max>\n	    </size>\n	   </hidden>\n	   <hidden>\n	    <ID>Hidden2</ID>\n	    <size>\n	    	<min>3</min>\n	    	<max>3</max>\n	    </size>\n	   </hidden>\n	   <output>\n	    <ID>Output1</ID>\n	    <size>\n	    	<min>3</min>\n	    	<max>3</max>\n	    </size>\n	   </output>\n	 </structure>\n	 <parameters>\n	 	<!--<valueparameter>learningrate</valueparameter>\n	 	<valueparameter>biasInput</valueparameter>\n	 	<valueparameter>biasHidden</valueparameter>\n	 	<valueparameter>momentum</valueparameter>\n	 	<comboparameter>ativationfunction</valueparameter>\n	 	<valueparameter>threshold</valueparameter>-->\n	 </parameters>\n	 <data>\n	 	<description>iris txt file with 3 classifications, 4 input vars</description>\n	 	<tabledescription>no input as table possible</tabledescription>\n	 	<filedescription>CSV file</filedescription>\n	 </data>\n  </description>\n<definition>\n<identifier><!-- will be generated --></identifier>\n<metadata>\n  <paradigm>classification</paradigm>\n  <name>Backpropagation Classification</name>\n  <description>Iris Classification Example</description>\n  <version>\n    <major>1</major>\n    <minor>0</minor>\n  </version>\n</metadata>\n<creator>\n  <name>Ronald Fisher</name>\n  <contact>ronald.fisher@institution.com</contact>\n</creator>\n<problemDomain>\n  <propagationType type="feedforward">\n    <learningType>supervised</learningType>\n  </propagationType>\n  <applicationField>Classification</applicationField>\n  <networkType>Backpropagation</networkType>\n  <problemType>Classifiers</problemType>\n</problemDomain>\n<endpoints>\n  <train>true</train>\n</endpoints>\n<executionEnvironment>\n	<serial>true</serial>\n</executionEnvironment>\n<structure>\n   <input>\n    <ID>Input1</ID>\n    <size>4</size>\n   </input>\n   <hidden>\n    <ID>Hidden1</ID>\n    <size>3</size>\n   </hidden>\n   <hidden>\n    <ID>Hidden2</ID>\n    <size>3</size>\n   </hidden>\n   <output>\n    <ID>Output1</ID>\n    <size>3</size>\n   </output>\n   <connections>\n   	<!--<fullconnected>\n   		<fromblock>Input1</fromblock>\n   		<toblock>Hidden1</toblock>\n   		<fromblock>Hidden1</fromblock>\n   		<toblock>Output1</toblock>\n   	</fullconnected>-->\n   </connections>\n </structure>\n <resultSchema>\n 	<instance>true</instance>\n 	<training>true</training>\n </resultSchema>\n <parameters>\n 	<valueparameter name="learningrate">0.1</valueparameter>\n	<comboparameter name="activationfunction">tanh</comboparameter>\n	<valueparameter name="iterations">500</valueparameter>\n	<valueparameter name="seed">6</valueparameter>\n </parameters>\n <data>\n 	<description>iris txt file with 3 classifications, 4 input vars</description>\n	<dataSchemaID>name/iris.txt</dataSchemaID>\n </data>\n</definition></vinnsl>'

VINNSLID=$(curl --insecure -s --request GET --url 'https://cluster.local/status/' | jq -r 'keys[0]')
echo Neural Network $VINNSLID created

echo Opening Firefox ...
nohup firefox >/dev/null 2>&1 &
echo Opening Postman ...
nohup postman >/dev/null 2>&1 &

read -n1 -rsp $'Press any key to start training...\n'

echo Training in Progress ...
curl --insecure --request PUT \
  --url "https://cluster.local/worker/queue/$VINNSLID"

bash -c 'while [[ "$(curl --insecure -s 'https://cluster.local/status/' | jq -r '.[]')" != "FINISHED" ]]; do sleep 5; done'
echo "                                                ";
echo Training finished.

pause