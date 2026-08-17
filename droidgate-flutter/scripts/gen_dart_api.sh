LOCAL_DIR=$(
    cd $(dirname $0)
    pwd
)
cd $LOCAL_DIR/..
dart run build_runner build --delete-conflicting-outputs