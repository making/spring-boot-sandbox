require "rexml/document"
require "net/https"

def get_latest_version(name)
  http = Net::HTTP.new("repo.maven.apache.org", 443)
  http.use_ssl = true
  response = http.get("/maven2/#{name}/maven-metadata.xml")
  REXML::Document.new(response.body).elements["metadata/versioning/latest"].get_text
end

spring_boot_version = get_latest_version("org/springframework/boot/spring-boot")
doma_version = get_latest_version("org/seasar/doma/doma-core")
doma_spring_boot_version = get_latest_version("org/seasar/doma/boot/doma-spring-boot-starter")
testcontainers_version = get_latest_version("org/testcontainers/testcontainers-bom")

File.open("pom.xml", "w") { |out|
  out.puts <<_EOS_
<?xml version='1.0' encoding='UTF-8'?>
<project xsi:schemaLocation='http://maven.apache.org/POM/4.0.0 https://maven.apache.org/xsd/maven-4.0.0.xsd' xmlns='http://maven.apache.org/POM/4.0.0' xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance'>
	<modelVersion>4.0.0</modelVersion>
	<parent>
		<groupId>org.springframework.boot</groupId>
		<artifactId>spring-boot-starter-parent</artifactId>
		<version>#{spring_boot_version}</version>
		<relativePath/> <!-- lookup parent from repository -->
	</parent>
	<groupId>com.example</groupId>
	<artifactId>spring-boot-sandbox-parent</artifactId>
	<version>0.0.1-SNAPSHOT</version>
	<packaging>pom</packaging>

	<properties>
		<java.version>17</java.version>
		<spring-cloud.version>2022.0.0-RC2</spring-cloud.version>
		<spring-cloud-aws.version>2.4.2</spring-cloud-aws.version>
		<doma.version>#{doma_version}</doma.version>
		<doma.boot.version>#{doma_spring_boot_version}</doma.boot.version>
		<testcontainers.version>#{testcontainers_version}</testcontainers.version>
		<database-rider.version>1.35.0</database-rider.version>
		<springdoc.version>2.0.0</springdoc.version>
		<mybatis-spring-boot-starter.version>3.0.0-SNAPSHOT</mybatis-spring-boot-starter.version>
		<mybatis-generator-maven-plugin.version>1.4.1</mybatis-generator-maven-plugin.version>
		<greenmail.version>2.0.0-alpha-2</greenmail.version>
		<r2dbc.version>1.0.0.M7</r2dbc.version>
		<argLine>-Duser.language=ja -Duser.country=JP -Duser.timezone=Asia/Tokyo</argLine>
	</properties>

	<modules>
_EOS_

  poms = `git ls-files | grep /pom\.xml | xargs -I {} dirname {}$`.split("\n")
  poms.each do |mod|
	out.puts "		<module>#{mod}</module>"
  end

  out.puts <<_EOS_
	</modules>

	<dependencyManagement>
		<dependencies>
			<dependency>
				<groupId>org.springframework.cloud</groupId>
				<artifactId>spring-cloud-dependencies</artifactId>
				<version>${spring-cloud.version}</version>
				<type>pom</type>
				<scope>import</scope>
			</dependency>
			<dependency>
				<groupId>org.testcontainers</groupId>
				<artifactId>testcontainers-bom</artifactId>
				<version>${testcontainers.version}</version>
				<type>pom</type>
				<scope>import</scope>
			</dependency>
			<dependency>
				<groupId>io.awspring.cloud</groupId>
				<artifactId>spring-cloud-aws-dependencies</artifactId>
				<version>${spring-cloud-aws.version}</version>
				<type>pom</type>
				<scope>import</scope>
			</dependency>
			<dependency>
				<groupId>com.github.database-rider</groupId>
				<artifactId>rider-junit5</artifactId>
				<version>${database-rider.version}</version>
			</dependency>
			<dependency>
				<groupId>org.springdoc</groupId>
				<artifactId>springdoc-openapi-starter-webmvc-ui</artifactId>
				<version>${springdoc.version}</version>
			</dependency>
			<dependency>
				<groupId>org.mybatis.spring.boot</groupId>
				<artifactId>mybatis-spring-boot-starter</artifactId>
				<version>${mybatis-spring-boot-starter.version}</version>
			</dependency>
			<dependency>
				<groupId>com.icegreen</groupId>
				<artifactId>greenmail-junit5</artifactId>
				<version>${greenmail.version}</version>
			</dependency>
			<dependency>
				<groupId>io.r2dbc</groupId>
				<artifactId>r2dbc-client</artifactId>
				<version>${r2dbc.version}</version>
			</dependency>
			<dependency>
				<groupId>io.r2dbc</groupId>
				<artifactId>r2dbc-postgresql</artifactId>
				<version>${r2dbc.version}</version>
			</dependency>
		</dependencies>
	</dependencyManagement>

	<build>
		<pluginManagement>
			<plugins>
				<plugin>
					<groupId>org.mybatis.generator</groupId>
					<artifactId>mybatis-generator-maven-plugin</artifactId>
					<version>${mybatis-generator-maven-plugin.version}</version>
				 </plugin>
			</plugins>
		</pluginManagement>
	</build>

	<repositories>
		<repository>
			<id>spring-milestones</id>
			<name>Spring Milestones</name>
			<url>https://repo.spring.io/milestone</url>
			<snapshots>
				<enabled>false</enabled>
			</snapshots>
		</repository>
		<repository>
			<id>maven-snapshots</id>
			<name>Maven Snapshots</name>
			<url>https://oss.sonatype.org/content/repositories/snapshots</url>
			<snapshots>
				<enabled>true</enabled>
			</snapshots>
		</repository>
	</repositories>

	<pluginRepositories>
		<pluginRepository>
			<id>spring-milestones</id>
			<name>Spring Milestones</name>
			<url>https://repo.spring.io/milestone</url>
			<snapshots>
				<enabled>false</enabled>
			</snapshots>
		</pluginRepository>
	</pluginRepositories>

</project>
_EOS_
}

