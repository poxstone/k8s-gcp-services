# k8s-gcp-services
Deploy docker

## variables
```bash
export TF_VAR_PROJECT_ID="${GOOGLE_CLOUD_PROJECT}";
```

## Prepare GCP

```bash
cd terraform;
terraform init;
terraform apply;
```

## Prepare GCP

```bash
export IMAGE_TAG="gcr.io/${GOOGLE_CLOUD_PROJECT}/ubuntu20-jdk8";
docker build -t "${IMAGE_TAG}" .;
docker run --rm -it -p 8080:8080 -p 4848:4848 -p 8181:8181 "${IMAGE_TAG}";
```
## push
```bash
gcloud auth configure-docker;
docker push "${IMAGE_TAG}";
```
