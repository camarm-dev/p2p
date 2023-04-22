#!/bin/bash
echo "Packing cli/p2p.rb in packed/p2p"
echo "Generating p2p bin"
echo "#!/bin/bash
ruby /usr/lib/p2p/cli/p2p.rb \$1 \$2 \$3 \$4" > packed/p2p
echo "Copying libs and utils"
cp lib -r packed/p2p-libs
cp cli -r packed/p2p-libs
echo "Replacing import paths"
ruby scripts/utils/full-path.rb packed/p2p-libs
echo "Making a tarball of p2p-libs"
tar -czvf packed/p2p-libs.tar.gz packed/p2p-libs
echo "Done."
