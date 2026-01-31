package secret

import (
	"fmt"

	"github.com/zalando/go-keyring"
)

const serviceName = "fileguardian"

type KeyringStore struct{}

func NewKeyringStore() *KeyringStore {
	return &KeyringStore{}
}

func (k *KeyringStore) Set(provider, key, value string) error {
	return keyring.Set(serviceName, secretKey(provider, key), value)
}

func (k *KeyringStore) Get(provider, key string) (string, error) {
	val, err := keyring.Get(serviceName, secretKey(provider, key))
	if err != nil {
		if err == keyring.ErrNotFound {
			return "", nil
		}
		return "", err
	}
	return val, nil
}

func (k *KeyringStore) Delete(provider, key string) error {
	err := keyring.Delete(serviceName, secretKey(provider, key))
	if err != nil && err != keyring.ErrNotFound {
		return err
	}
	return nil
}

func secretKey(provider, key string) string {
	return fmt.Sprintf("%s/%s", provider, key)
}
