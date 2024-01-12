function df {
    # df outputs in 1kb blocks, so a value of 104857600 equals 100*1024*1024kB = 100GB
    case $3 in
        100GB/)
            echo -n "
Avail
104857600"
        ;;
        10GB/)
            echo -n "
Avail
10485760"
        ;;
        *)
            echo "Unknown mountpoint"
        ;;
    esac
}

setup() {
    source $BATS_TEST_DIRNAME/../setup/pi/create-backingfiles.sh
    load 'test_helper/bats-support/load'
    load 'test_helper/bats-assert/load'
    export -f df
}

@test "get available space (-10GB) in 1kB blocks" {
    export -f df
    run available_space "100GB"
    assert_output '94371840'
}

@test "get not enough available space (-10GB) in 1kB blocks" {
    export -f df
    run available_space "10GB"
    assert_output '0'
}
