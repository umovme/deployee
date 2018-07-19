package as

// Group controls a AutoScalling group
type Group interface {
	Length(string) (int32, error)
	GetInstances(string) (out []Instance, err error)
	ListGroups() (out []GroupDetails, err error)
	Update(GroupDetails) (err error)
	Describe(string) (out GroupDetails, err error)
}

// Instance contains details about a virtual machine
type Instance struct {
	ID         string
	Zone       string
	PrivateDNS string
	PrivateIP  string
	PublicDNS  string
	PublicIP   string
}

// GroupDetails contains a details about an autocalling group
type GroupDetails struct {
	Name     string `json:"name"`
	Minimum  int32  `json:"min"`
	Current  int32  `json:"current"`
	Maximum  int32  `json:"max"`
	Updating bool   `json:"isUpdating"`

	Instances []Instance `json:"instances,omitempty"`
}
