name = E6S
URL = https://github.com/HttpAnimation/E6Scripts.git

cd ~/
git clone -b main $"URL"
cd ~/
mv E6Scripts $"name"
cd $"name"
mv UserConfig.json Config.json
chmod +x ParseFavs.sh
chmod +x E6Scripts.sh
echo "Done Installing"