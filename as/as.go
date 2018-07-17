package as

// Group controls a AutoScalling group
type Group interface {
	Length(string) (int32, error)
	ListGroups() (out []GroupDetails, err error)
}

// GroupDetails contains a details about an autocalling group
type GroupDetails struct {
	Name    string `json:"group"`
	Minimum int32  `json:"min"`
	Current int32  `json:"current"`
	Maximum int32  `json:"max"`
}
