function df {
    echo "     Avail
104857600"
}

setup() {
    source $BATS_TEST_DIRNAME/../setup/pi/create-backingfiles.sh
    load 'test_helper/bats-support/load'
    load 'test_helper/bats-assert/load'
    export -f df
}

@test "calculate valid size in GB" {
    # 100GB - 64GB > 0 -> 64GB
    run calc_size '64G' '/'
    assert_output '67108864'
}

@test "calculate valid size in %" {
    # (100GB - 10GB buffer) * 10% = 90GB
    run calc_size '10%' '/'
    assert_output '9437184'
}

@test "calculate too big size in GB" {
    # 100GB - 10GB buffer = 90GB
    run calc_size '1024G' '/'
    assert_output '94371840'
}

@test "calculate invalid size in %" {
    # (100GB - 10GB) * 150% > 100GB - 10GB -> 90GB
    run calc_size '150%' '/'
    assert_output '94371840'
}

@test "calculate invalid unit" {
    run calc_size '10Gi' '/'
    [[ status -gt 0 ]]
}

