package as

// Group controls a AutoScalling group
type Group interface {
	Length(string) (int32, error)
}
