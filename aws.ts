import * as pulumi from "@pulumi/pulumi";
import * as aws from "@pulumi/aws";
import * as tls from "@pulumi/tls";

const config = new pulumi.Config();
const keyName = config.requireObject("keyName");
const dbUsername = config.get("dbUsername") || "admin";
const dbPassword = config.get("dbPassword") || "TUDproj23";
const example = new tls.PrivateKey("example", {
    algorithm: "RSA",
    rsaBits: 4096,
});
const generatedKey = new aws.ec2.KeyPair("generatedKey", {publicKey: example.publicKeyOpenssh});

const ec2sec = new aws.ec2.SecurityGroup("ec2sec", {
    egress: [
        {
            cidrBlocks: ["0.0.0.0/0"],
            fromPort: 80,
            protocol: "tcp",
            toPort: 80,
        },
        {
            cidrBlocks: ["0.0.0.0/0"],
            fromPort: 443,
            protocol: "tcp",
            toPort: 443,
        },
        {
            cidrBlocks: ["0.0.0.0/0"],
            fromPort: 3306,
            protocol: "tcp",
            toPort: 3306,
        },
    ],
    ingress: [
        {
            cidrBlocks: ["0.0.0.0/0"],
            fromPort: 22,
            protocol: "tcp",
            toPort: 22,
        },
        {
            cidrBlocks: ["0.0.0.0/0"],
            fromPort: 80,
            protocol: "tcp",
            toPort: 80,
        },
        {
            cidrBlocks: ["0.0.0.0/0"],
            fromPort: 443,
            protocol: "tcp",
            toPort: 443,
        },
        {
            cidrBlocks: ["0.0.0.0/0"],
            fromPort: 3306,
            protocol: "tcp",
            toPort: 3306,
        },
    ],
    namePrefix: "ec2sec",
});

const apiServer = new aws.ec2.Instance("apiServer", {
    ami: "ami-0e1dc7c0757fa9cdc",
    instanceType: "t2.micro",
    keyName: aws_key_pair.generated_key.key_name,
    associatePublicIpAddress: true,
    vpcSecurityGroupIds: [ec2sec.id],
});

export const privateKey = tls_private_key.example.private_key_pem;
// Create a SQL Database
const mysqldb = new aws.rds.Instance("mysqldb", {
    allocatedStorage: 20,
    engine: "mysql",
    engineVersion: "8.0.23",
    instanceClass: "db.t2.micro",
    dbName: "cars_db",
    username: _var.db_username,
    password: _var.db_password,
    publiclyAccessible: true,
    skipFinalSnapshot: true,
    vpcSecurityGroupIds: [ec2sec.id],
});
export const rdsEndpoint = mysqldb.endpoint;