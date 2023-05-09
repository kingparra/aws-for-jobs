package test

import (
	"fmt"
	"testing"
	"time"

	http_hlper "github.com/gruntwork-io/terratest/modules/http-helper"
	"github.com/gruntwork-io/terratest/modules/terraform"
)

func TestTerraformAwsHelloWorldExample(t *testing.T) {
	t.Parallel()

	terraformOptions := terraform.WithDefaultRetryableErrors(t,
		&terraform.Options{
			TerraformDir: "../terraform",
		})

	defer terraform.Destroy(t, terraformOptions)

	terraform.Validate(t, terraformOptions)

	terraform.InitAndApply(t, terraformOptions)

	publicIp := terraform.Output(t, terraformOptions, "public_ip")

	url := fmt.Sprintf("http://%s:8080", publicIp)

	http_hlper.HttpGetWithRetry(t, url, nil, 200, "Hello, world!", 30, 5*time.Second)
}
