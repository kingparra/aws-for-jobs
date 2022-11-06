# These resources were create with the web ui and imported using "terraforming"
#
resource "aws_internet_gateway" "midterm-igw" {
    vpc_id = aws_vpc.vpc.id
    tags {
        Name = "midterm-igw"
    }
}


resource "aws_route_table" "midterm-rtb-private1-us-east-1a" {
    vpc_id = aws_vpc.vpc.id
    route {
        cidr_block = "0.0.0.0/0"
    }
    tags {
        "Name" = "midterm-rtb-private1-us-east-1a"
    }
}

resource "aws_route_table" "midterm-rtb-private2-us-east-1b" {
    vpc_id = aws_vpc.vpc.id
    route {
        cidr_block = "0.0.0.0/0"
    }
    tags {
        "Name" = "midterm-rtb-private2-us-east-1b"
    }
}

resource "aws_internet_gateway" "midterm-igw" {
    vpc_id = aws_vpc.vpc.id
    tags {
        "Name" = "midterm-igw"
    }
}

resource "aws_route_table" "midterm-rtb-public" {
    vpc_id = aws_vpc.vpc.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.midterm-igw.id
    }

    tags {
        "Name" = "midterm-rtb-public"
    }
}

resource "aws_route_table" "midterm-rtb-private1-us-east-1a" {
    vpc_id = aws_vpc.vpc.id
    route {
        cidr_block = "0.0.0.0/0"
    }
    tags {
        "Name" = "midterm-rtb-private1-us-east-1a"
    }
}

resource "aws_route_table" "midterm-rtb-private2-us-east-1b" {
    vpc_id = aws_vpc.vpc.id
    route {
        cidr_block = "0.0.0.0/0"
    }
    tags {
        "Name" = "midterm-rtb-private2-us-east-1b"
    }
}

resource "aws_route_table_association" "midterm-rtb-public-rtbassoc-07944fea09c51bc54" {
    route_table_id = aws_route_table.midterm-rtb-public.id
    subnet_id = aws_subnet.subnet-0b5472b288c48ac87-midterm-subnet-public2-us-east-1b
}

resource "aws_route_table_association" "midterm-rtb-public-rtbassoc-02b1538704df4e32a" {
    route_table_id = aws_route_table.midterm-rtb-public.id
    subnet_id = "subnet-05b228d4a4578782d"
}

resource "aws_route_table_association" "midterm-rtb-private1-us-east-1a-rtbassoc-0eb83f5e0c956c40b" {
    route_table_id = "rtb-05d9db6d479c8a720"
    subnet_id = "subnet-00e517c733f3793c7"
}

resource "aws_route_table_association" "midterm-rtb-private2-us-east-1b-rtbassoc-007a8e6bd647f36b9" {
    route_table_id = "rtb-06e6e9dafbc1c59bb"
    subnet_id = "subnet-023f4bbe3d8e5dac8"
}

resource "aws_subnet" "subnet-023f4bbe3d8e5dac8-midterm-subnet-private2-us-east-1b" {
    vpc_id = aws_vpc.vpc.id
    cidr_block              = "10.0.3.0/24"
    availability_zone       = "us-east-1b"
    map_public_ip_on_launch = false

    tags {
        "Name" = "midterm-subnet-private2-us-east-1b"
    }
}

resource "aws_subnet" "subnet-05b228d4a4578782d-midterm-subnet-public1-us-east-1a" {
    vpc_id = aws_vpc.vpc.id
    cidr_block              = "10.0.0.0/24"
    availability_zone       = "us-east-1a"
    map_public_ip_on_launch = false
    tags {
        "Name" = "midterm-subnet-public1-us-east-1a"
    }
}

resource "aws_subnet" "subnet-0b5472b288c48ac87-midterm-subnet-public2-us-east-1b" {
    vpc_id = aws_vpc.vpc.id
    cidr_block              = "10.0.1.0/24"
    availability_zone       = "us-east-1b"
    map_public_ip_on_launch = false
    tags {
        "Name" = "midterm-subnet-public2-us-east-1b"
    }
}

resource "aws_subnet" "subnet-00e517c733f3793c7-midterm-subnet-private1-us-east-1a" {
    vpc_id = aws_vpc.vpc.id
    cidr_block              = "10.0.2.0/24"
    availability_zone       = "us-east-1a"
    map_public_ip_on_launch = false
    tags {
        "Name" = "midterm-subnet-private1-us-east-1a"
    }
}
